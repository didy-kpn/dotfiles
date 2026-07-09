# Hermes Agent on microvm.nix 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** NixOS 上で microvm.nix を使用して 2 台のマイクロVM を起動し、各 VM 内で Hermes Agent + Hermes WebUI を動作させる。

**Architecture:** ホスト上に microbr ブリッジ + NAT でネットワークを構成、cloud-hypervisor で 2 台の VM (2 vCPU / 2 GB RAM) を起動。各 VM は virtiofs でホストの /nix/store を読み取り専用共有、Hermes の状態 (~/.hermes/) は virtiofs で永続化。WebUI へはホストの DNAT (8781→VM1:8787, 8782→VM2:8787) でアクセス。

**Tech Stack:** NixOS 25.11, microvm.nix, cloud-hypervisor, Hermes Agent (llm-agents), Hermes WebUI, OpenCode Go

## Global Constraints

- NixOS 25.11 (nixos-25.11), x86_64-linux
- 全ての flake input は `inputs.nixpkgs.follows = "nixpkgs"` でバージョン同期
- microvm.nix の Cachix サブスティテューター (`microvm.cachix.org`) を使用
- VM 内では Nix ビルドを行わない (writableStoreOverlay 不使用)
- VM リソース: 2 vCPU / 2 GB RAM / balloon 有効
- シークレットファイルはホスト上で `0600` パーミッション厳守
- ファイルパスは `/home/kpn-didy/git_repositories/hermes-works/` がルート

---
## ファイル構造

```
hermes-works/
├── flake.nix                           # [Task 1] ルート flake
├── hosts/
│   └── kpn-didy-nixos/
│       ├── default.nix                 # [Task 2] ホスト設定 (microvm host module + ネットワーク)
│       ├── microvm-base.nix            # [Task 3] VM ベース設定 (関数)
│       ├── microvm.nix                 # [Task 5] VM 定義 (vm1, vm2 宣言)
│       ├── microvms/
│       │   └── hermes-vm.nix           # [Task 5] Hermes Agent + WebUI (home-manager)
│       └── hardware-configuration.nix  # [Task 1] ハードウェア設定 (ホストからコピー)
├── packages/
│   └── hermes-webui/
│       └── default.nix                 # [Task 4] fetchFromGitHub + inline start script
├── vm-data/                            # [Task 7] (手動セットアップ)
│   ├── vm1/hermes-home/
│   ├── vm1/ssh-host-keys/
│   ├── vm2/hermes-home/
│   └── vm2/ssh-host-keys/
└── secrets/                            # [Task 7] (手動セットアップ)
    └── opencode-go-key
```

---
### Task 1: 初期ディレクトリ構造と flake.nix

**Files:**
- Create: `hermes-works/flake.nix`
- Create: `hermes-works/hosts/kpn-didy-nixos/hardware-configuration.nix`

**Interfaces:**
- Consumes: 既存の `dotfiles/flake.nix` の inputs・設定を参照
- Produces: `nixosConfigurations.kpn-didy-nixos` — 以降の Task が import するホスト設定

- [ ] **Step 1: ディレクトリ構造を作成**

```bash
mkdir -p /home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/microvms
mkdir -p /home/kpn-didy/git_repositories/hermes-works/packages/hermes-webui
mkdir -p /home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/hermes-home
mkdir -p /home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/ssh-host-keys
mkdir -p /home/kpn-didy/git_repositories/hermes-works/vm-data/vm2/hermes-home
mkdir -p /home/kpn-didy/git_repositories/hermes-works/vm-data/vm2/ssh-host-keys
mkdir -p /home/kpn-didy/git_repositories/hermes-works/secrets
```

- [ ] **Step 2: ハードウェア設定をコピー**

```bash
cp /etc/nixos/hardware-configuration.nix \
  /home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/hardware-configuration.nix
cp /home/kpn-didy/dotfiles/hosts/kpn-didy-nixos/default.nix \
  /home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/default.nix
```

- [ ] **Step 3: flake.nix を作成**

`/home/kpn-didy/git_repositories/hermes-works/flake.nix` を作成。既存の dotfiles/flake.nix をベースに microvm input と Cachix 設定を追加:

```nix
{
  description = "kpn-didy's NixOS configuration with Hermes microVMs";

  nixConfig = {
    extra-substituters = [ "https://microvm.cachix.org" ];
    extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rKLY7CQ33mWMsyZLJmB3x+ro0FdN98=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-msb.url = "github:conao3/nix-msb";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, llm-agents, nix-msb, microvm, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system}.hermes-webui = pkgs.callPackage ./packages/hermes-webui {
        hermes-agent = llm-agents.packages.${system}.hermes-agent;
      };

      nixosConfigurations.kpn-didy-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/kpn-didy-nixos/default.nix
          ./hosts/kpn-didy-nixos/microvm.nix
          home-manager.nixosModules.home-manager
          microvm.nixosModules.host
          {
            nixpkgs.overlays = [ nix-msb.overlays.default ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs llm-agents system;
            };
            # home-manager.users.kpn-didy は default.nix から読み込まれる
          }
        ];
      };
    };
}
```

- [ ] **Step 4: ビルドが通ることを確認**

```bash
cd /home/kpn-didy/git_repositories/hermes-works
nix flake check 2>&1 | head -20
```

Expected: エラーなし (microvm.nix 等が未完成でも `nix flake check` は warm で通る)

- [ ] **Step 5: 必要なら flake.lock を生成**

```bash
nix flake lock
```

- [ ] **Step 6: Commit**

```bash
cd /home/kpn-didy/git_repositories/hermes-works
git init
git add flake.nix hosts/
git commit -m "feat: initial flake with microvm.nix input"
```

---
### Task 2: ホストネットワーク設定 (microbr ブリッジ + NAT + DNAT)

**Files:**
- Modify: `hosts/kpn-didy-nixos/default.nix` (既存設定の流用 + microbr/NAT/DNAT 追加)

**Interfaces:**
- Consumes: `flake.nix` で提供される `nixpkgs`, `config`, `lib`, `pkgs`
- Produces: ホスト上の `microbr` ブリッジ (192.168.83.1/24), NAT, DNAT ルール

- [ ] **Step 1: 外部インターフェースを確認**

```bash
ip route show default | awk '{print $5}'
```

Expected: `wlp2s0` または `eth0` 等。このインターフェース名を NAT の `externalInterface` に使用。

- [ ] **Step 2: default.nix の末尾に microvm ネットワーク設定を追記**

`/home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/default.nix` を開き、以下をファイル末尾 (`}` の直前) に追加:

```nix
  # microvm ネットワーク設定
  systemd.network = {
    netdevs."20-microbr" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "microbr";
      };
    };
    networks."20-microbr" = {
      matchConfig.Name = "microbr";
      addresses = [ { Address = "192.168.83.1/24"; } ];
      networkConfig.ConfigureWithoutCarrier = true;
    };
    networks."21-microvm-tap" = {
      matchConfig.Name = "microvm*";
      networkConfig.Bridge = "microbr";
    };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "microbr" ];
    externalInterface = "wlp2s0"; # ↑で確認したインターフェース名に変更
  };

  # WebUI アクセス用 DNAT (ホスト:8781 → VM1:8787, ホスト:8782 → VM2:8787)
  networking.nat.forwardPorts = [
    { sourcePort = 8781; destination = "192.168.83.11:8787"; proto = "tcp"; }
    { sourcePort = 8782; destination = "192.168.83.12:8787"; proto = "tcp"; }
  ];

  # DNAT 用ポートを開ける
  networking.firewall.allowedTCPPorts = [ 8781 8782 ];
```

- [ ] **Step 3: ビルド確認**

```bash
cd /home/kpn-didy/git_repositories/hermes-works
nixos-rebuild dry-build --flake .#kpn-didy-nixos 2>&1 | tail -20
```

Expected: エラーなくビルド完了

- [ ] **Step 4: Commit**

```bash
git add hosts/kpn-didy-nixos/default.nix
git commit -m "feat: add microbr bridge, NAT, and DNAT for microVMs"
```

---
### Task 3: microvm-base.nix (VM ベース設定)

**Files:**
- Create: `hosts/kpn-didy-nixos/microvm-base.nix`

**Interfaces:**
- Consumes: 引数 `{ hostName, ipAddress, tapId, mac, hermesHome }` — Task 5 から呼ばれる
- Produces: VM の基本 NixOS 設定モジュール

- [ ] **Step 1: microvm-base.nix を作成**

`/home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/microvm-base.nix`:

```nix
{ hostName, ipAddress, tapId, mac, hermesHome }:
{ config, lib, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  networking.hostName = hostName;
  system.stateVersion = "25.11";

  # systemd-networkd + resolved
  services.resolved.enable = true;
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."10-e" = {
    matchConfig.Name = "e*";
    addresses = [ { Address = "${ipAddress}/24"; } ];
    routes = [ { Gateway = "192.168.83.1"; } ];
  };
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  # VM 内 firewall (22, 8787 のみ許可)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8787 ];
  };

  # SSH
  services.openssh = {
    enable = true;
    hostKeys = [{
      path = "/etc/ssh/host-keys/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  # ユーザー設定（ホストと uid/gid を合わせる）
  users.users.kpn-didy = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # swap (OOM 対策)
  swapDevices = [{ device = "/var/swapfile"; size = 2048; }];

  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 2;
    mem = 2048;
    balloon = true;

    volumes = [{
      mountPoint = "/var";
      image = "var.img";
      size = 8192;
    }];

    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        proto = "virtiofs";
        tag = "hermes-home";
        source = hermesHome;
        mountPoint = "/home/kpn-didy/.hermes";
      }
      {
        proto = "virtiofs";
        tag = "ssh-keys";
        source = "${hermesHome}/../ssh-host-keys";
        mountPoint = "/etc/ssh/host-keys";
      }
    ];

    interfaces = [{
      type = "tap";
      id = tapId;
      mac = mac;
    }];
  };

  # systemd shutdown 高速化
  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";

  # シャットダウン時の deadlock 回避（/nix/store の umount 防止）
  systemd.mounts = [
    {
      what = "store";
      where = "/nix/store";
      overrideStrategy = "asDropin";
      unitConfig.DefaultDependencies = false;
    }
  ];
}
```

- [ ] **Step 2: Commit**

```bash
git add hosts/kpn-didy-nixos/microvm-base.nix
git commit -m "feat: add microvm-base.nix with shared VM configuration"
```

---
### Task 4: Hermes WebUI パッケージ

**Files:**
- Create: `packages/hermes-webui/default.nix`


**Interfaces:**
- Consumes: `pkgs.fetchFromGitHub`, `pkgs.python3`, `pkgs.hermes-agent`
- Produces: `hermesWebui` パッケージ (derivation) — Task 5 で使用

- [ ] **Step 1: Nix derivation を作成**

`/home/kpn-didy/git_repositories/hermes-works/packages/hermes-webui/default.nix`:

```nix
{ pkgs, lib, stdenv, fetchFromGitHub, python3, hermes-agent }:

let
  webui-src = fetchFromGitHub {
    owner = "nesquena";
    repo = "hermes-webui";
    rev = "main";  # または特定のコミット
    hash = "";     # 初回ビルド後に修正
  };

in
stdenv.mkDerivation {
  pname = "hermes-webui";
  version = "latest";

  src = webui-src;

  buildInputs = [ python3 hermes-agent ];

  buildPhase = ''
    # requirements.txt の依存を確認 (pyyaml, cryptography 等)
    # これらは nixpkgs の python3Packages にある
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/hermes-webui
    cp -r . $out/share/hermes-webui/
    cat > $out/bin/hermes-webui << 'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
cd ${webui-src}
export PYTHONPATH="${python3.sitePackages}:${hermes-agent}/${python3.sitePackages}:$PYTHONPATH"
exec ${python3}/bin/python3 bootstrap.py --host 0.0.0.0 --port 8787 "$@"
SCRIPT
    chmod +x $out/bin/hermes-webui
  '';

  meta = {
    description = "Hermes Web UI - browser interface for Hermes Agent";
    homepage = "https://github.com/nesquena/hermes-webui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
```

- [ ] **Step 2: ハッシュを修正するため一旦ビルド**

```bash
cd /home/kpn-didy/git_repositories/hermes-works
# 初回は hash が不明なのでエラーになる。出力から hash をコピー:
nix build '.#hermes-webui' 2>&1 | grep -i "hash"
# 出力例: hash 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
# この値で packages/hermes-webui/default.nix の hash を更新
```

- [ ] **Step 3: ハッシュ反映後、再ビルド確認**

```bash
nix build '.#hermes-webui' 2>&1 | tail -10
```

- [ ] **Step 4: 修正後のハッシュを default.nix に反映して commit**

```bash
git add packages/hermes-webui/
git commit -m "feat: add hermes-webui package"
```

---
### Task 5: microvm.nix (VM 定義) + hermes-vm.nix (Hermes 設定)

**Files:**
- Create: `hosts/kpn-didy-nixos/microvm.nix`
- Create: `hosts/kpn-didy-nixos/microvms/hermes-vm.nix`

**Interfaces:**
- Consumes: `microvm-base.nix` (from Task 3), `hermesWebui` (from Task 4)
- Produces: `microvm.vms.vm1`, `microvm.vms.vm2` — ホストの systemd サービスとして起動可能に

- [ ] **Step 1: hermes-vm.nix を作成**

`/home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/microvms/hermes-vm.nix`:

```nix
{ config, lib, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hermesWebui = pkgs.callPackage ../../../packages/hermes-webui {
    hermes-agent = inputs.llm-agents.packages.${system}.hermes-agent;
  };
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.users.kpn-didy = {
    home.username = "kpn-didy";
    home.homeDirectory = "/home/kpn-didy";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.hermes-agent
      hermesWebui
      git
      zsh
      ripgrep
      fd
      curl
      wget
    ];

    # Hermes Agent 設定は virtiofs 経由でホスト側から供給されるため、
    # home-manager の home.file では生成しない。
    # vm-data/<vm>/hermes-home/ にホスト側で事前配置する。
    # 詳細は Task 7 参照。

    # WebUI systemd user service
    systemd.user.services.hermes-webui = {
      Unit = {
        Description = "Hermes Web UI";
        After = [ "network.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${hermesWebui}/bin/hermes-webui";
        Restart = "on-failure";
        RestartSec = 5;
        Environment = "HERMES_HOME=%h/.hermes";
      };
      Install.WantedBy = [ "default.target" ];
    };

    programs.zsh.enable = true;
    programs.home-manager.enable = true;
  };
}
```

- [ ] **Step 2: microvm.nix を作成**

`/home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/microvm.nix`:

```nix
{ config, lib, pkgs, inputs, ... }:

let
  microvmBase = import ./microvm-base.nix;
in
{
  microvm.vms.vm1 = {
    autostart = false;
    config = { ... }: {
      imports = [
        inputs.microvm.nixosModules.microvm
        (microvmBase {
          hostName = "vm1";
          ipAddress = "192.168.83.11";
          tapId = "microvm1";
          mac = "02:00:00:00:00:01";
          hermesHome = "/home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/hermes-home";
        })
        ./microvms/hermes-vm.nix
      ];
    };
  };

  microvm.vms.vm2 = {
    autostart = false;
    config = { ... }: {
      imports = [
        inputs.microvm.nixosModules.microvm
        (microvmBase {
          hostName = "vm2";
          ipAddress = "192.168.83.12";
          tapId = "microvm2";
          mac = "02:00:00:00:00:02";
          hermesHome = "/home/kpn-didy/git_repositories/hermes-works/vm-data/vm2/hermes-home";
        })
        ./microvms/hermes-vm.nix
      ];
    };
  };
}
```

- [ ] **Step 3: ビルド確認**

```bash
cd /home/kpn-didy/git_repositories/hermes-works
nixos-rebuild dry-build --flake .#kpn-didy-nixos 2>&1 | tail -30
```

Expected: エラーなくビルド完了 (hash エラーが出たら Task 4 で修正)

- [ ] **Step 4: Commit**

```bash
git add hosts/kpn-didy-nixos/microvm.nix hosts/kpn-didy-nixos/microvms/
git commit -m "feat: add microVM definitions and Hermes VM configuration"
```

---
### Task 6: 初回ビルド・デプロイ

**Files:** — (運用コマンド)

- [ ] **Step 1: 現在の設定をバックアップ**

```bash
cd /home/kpn-didy/git_repositories/hermes-works
nixos-rebuild build --flake .#kpn-didy-nixos 2>&1 | tail -10
```

- [ ] **Step 2: システムにデプロイ**

```bash
sudo nixos-rebuild switch --flake .#kpn-didy-nixos 2>&1 | tail -20
```

Expected: 再起動後、`ip link show microbr` でブリッジが存在することを確認

- [ ] **Step 3: microbr ブリッジを確認**

```bash
ip addr show microbr
ping -c 1 192.168.83.1
```

Expected: `192.168.83.1/24` が表示され、ping 応答がある

---
### Task 7: VM データ・シークレットのセットアップ

**Files:** — (手動作業)

- [ ] **Step 1: SSH ホスト鍵を生成**

```bash
ssh-keygen -t ed25519 -N "" \
  -f /home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/ssh-host-keys/ssh_host_ed25519_key
ssh-keygen -t ed25519 -N "" \
  -f /home/kpn-didy/git_repositories/hermes-works/vm-data/vm2/ssh-host-keys/ssh_host_ed25519_key
```

- [ ] **Step 2: Hermes 設定ファイルを事前作成 (ホスト側)**

```bash
# VM1 の Hermes 設定
cat > /home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/hermes-home/config.yaml << 'EOF'
model:
  provider: opencode-go
  default: deepseek-v4-flash
EOF

cat > /home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/hermes-home/.env << 'EOF'
OPENCODE_GO_API_KEY=$(cat /run/secrets/opencode-go-key)
EOF

# VM2 も同様
cp -r /home/kpn-didy/git_repositories/hermes-works/vm-data/vm1/hermes-home/* \
  /home/kpn-didy/git_repositories/hermes-works/vm-data/vm2/hermes-home/
```

- [ ] **Step 3: OpenCode Go の API キーを設定**

```bash
echo "sk-or-..." > /home/kpn-didy/git_repositories/hermes-works/secrets/opencode-go-key
chmod 0600 /home/kpn-didy/git_repositories/hermes-works/secrets/opencode-go-key
```

- [ ] **Step 4: microvm-base.nix に secrets 共有を追加**

`/home/kpn-didy/git_repositories/hermes-works/hosts/kpn-didy-nixos/microvm-base.nix` の `shares` リストに以下を追加:

```nix
      {
        proto = "virtiofs";
        tag = "secrets";
        source = "/home/kpn-didy/git_repositories/hermes-works/secrets";
        mountPoint = "/run/secrets";
      }
```

- [ ] **Step 4: 再ビルド**

```bash
sudo nixos-rebuild switch --flake .#kpn-didy-nixos
```

- [ ] **Step 5: Commit**

```bash
git add .
git commit -m "chore: initial vm-data and secrets setup"
```

---
### Task 8: VM 起動・動作確認

**Files:** — (テスト)

- [ ] **Step 1: VM1 を起動**

```bash
sudo systemctl start microvm@vm1
journalctl -u microvm@vm1 -f --no-pager 2>&1 | timeout 30 head -20
```

Expected: 数秒でブート完了

- [ ] **Step 2: VM1 のネットワークを確認**

```bash
ping -c 2 192.168.83.11
```

Expected: 応答がある

- [ ] **Step 3: VM1 に SSH 接続**

```bash
ssh -o StrictHostKeyChecking=accept-new kpn-didy@192.168.83.11 "hostname && hermes-agent --version"
```

Expected: `vm1` と hermes-agent のバージョンが表示される

- [ ] **Step 4: VM1 の環境変数を確認**

```bash
ssh kpn-didy@192.168.83.11 "cat ~/.hermes/.env"
```

Expected: `OPENCODE_GO_API_KEY=$(cat /run/secrets/opencode-go-key)` が表示される

- [ ] **Step 5: WebUI が起動しているか確認**

```bash
ssh kpn-didy@192.168.83.11 "curl -s http://localhost:8787/health | head -5"
# または systemctl --user status hermes-webui
```

Expected: HTTP 応答がある (またはサービスが active と表示)

- [ ] **Step 6: ホストからの DNAT を確認**

```bash
curl -s http://localhost:8781/health | head -5
```

Expected: VM1 の WebUI から応答がある

- [ ] **Step 7: VM2 も同様に起動・確認**

```bash
sudo systemctl start microvm@vm2
ping -c 2 192.168.83.12
ssh -o StrictHostKeyChecking=accept-new kpn-didy@192.168.83.12 "hostname"
curl -s http://localhost:8782/health | head -5
```

- [ ] **Step 8: Hermes Agent の初期セットアップ**

```bash
# VM1 で hermes の初回セットアップ
ssh kpn-didy@192.168.83.11 "hermes setup"
# 対話式: OpenCode Go のモデル一覧から deepseek-v4-flash を選択
```

Expected: Hermes が正常に起動する

---
## 補足: トラブルシューティング

### ビルド時の hash エラー
```
error: hash mismatch in fixed-output derivation ...
```
→ `packages/hermes-webui/default.nix` の `hash` を実際の値に更新。

### VM が起動しない
```
journalctl -u microvm@vm1 -n 50 --no-pager
```
- cloud-hypervisor のバイナリが見つからない → Cachix 設定を確認
- TAP デバイスが作成できない → `kpn-didy` が `kvm` グループに所属しているか確認

### WebUI にアクセスできない
- VM 内で `curl http://localhost:8787` が通るか確認
- ホストで `curl http://192.168.83.11:8787` が通るか確認
- DNAT ルール: `nft list nat` で転送ルールを確認

### Hermes が provider を見つけられない
- VM 内で `cat ~/.hermes/.env` で `OPENCODE_GO_API_KEY` が正しく設定されているか確認
- `hermes model` で provider 一覧を確認
