# Hermes Agent on microvm.nix — 設計書

## 概要

NixOS 上で microvm.nix を使用して 2 台の軽量マイクロVM を起動し、各 VM 内で Hermes Agent + Hermes WebUI を動作させる。LLM プロバイダーは OpenCode Go を使用する。

## ホスト環境

| 項目 | 値 |
|------|-----|
| OS | NixOS 25.11 (x86_64-linux) |
| CPU | AMD Ryzen 5 7430U (12 コア, AMD-V) |
| RAM | 15 GB |
| 仮想化 | KVM 有効 (kpn-didy は kvm グループ所属) |
| ネットワーク | Tailscale 稼働中, Cloudflare Tunnel 設定済み |
| 既存構成 | dotfiles (flake.nix, hosts/, home.nix) |

## アーキテクチャ

```
┌──────────────────────────────────────────────────────┐
│                    ホスト (NixOS)                      │
│                                                       │
│  ┌──────────┐   ┌──────────┐    ┌──────────────────┐ │
│  │ Tailscale │   │cloudflared│    │  microbr bridge  │ │
│  │           │   │           │    │ 192.168.83.1/24  │ │
│  └─────┬─────┘   └─────┬─────┘    └──┬──────┬───────┘ │
│        │               │             │      │         │
│  ┌─────┴─────────────────┴────────────┴──┐  │         │
│  │        NAT (masquerade)               │  │         │
│  └────────────────────────────────────────┘  │         │
│                                              │         │
│  ┌─────────────────┐    ┌─────────────────┐  │         │
│  │   VM1 (vm1)     │    │   VM2 (vm2)     │  │         │
│  │ 192.168.83.11   │    │ 192.168.83.12   │  │         │
│  │ 2 vCPU / 2 GB   │    │ 2 vCPU / 2 GB   │  │         │
│  │ cloud-hypervisor │    │ cloud-hypervisor │  │         │
│  │ Hermes Agent    │    │ Hermes Agent    │  │         │
│  │ Hermes WebUI    │    │ Hermes WebUI    │  │         │
│  │ port 8787       │    │ port 8787       │  │         │
│  └────────┬────────┘    └────────┬────────┘  │         │
│           │                      │            │         │
│           └──────────┬───────────┘            │         │
│                      │ TAP interfaces          │         │
│                      └─── microbr bridge ──────┘         │
└──────────────────────────────────────────────────────────┘
         │                        │
    localhost:8781           localhost:8782
    (DNAT → VM1:8787)       (DNAT → VM2:8787)
```

## ディレクトリ構造

```
/home/kpn-didy/git_repositories/hermes-works/
├── flake.nix                      # ルート flake
├── hosts/
│   └── kpn-didy-nixos/
│       ├── default.nix            # ホスト設定 (microvm host module + microbr/NAT)
│       ├── microvm.nix            # VM 定義 (vm1, vm2 を宣言)
│       ├── microvm-base.nix       # VM ベース設定 (共通関数)
│       └── microvms/
│           └── hermes-vm.nix      # Hermes Agent + WebUI 設定 (home-manager)
├── vm-data/
│   ├── vm1/
│   │   ├── hermes-home/           # ~/.hermes/ 永続化先 (virtiofs)
│   │   └── ssh-host-keys/
│   └── vm2/
│       ├── hermes-home/
│       └── ssh-host-keys/
├── packages/
│   └── hermes-webui/
│       ├── default.nix            # fetchFromGitHub + buildEnv
│       └── start-webui.sh
└── secrets/
    └── opencode-go-key            # 0600 パーミッション
```

## ネットワーク構成

### ブリッジ (microbr)

- ホスト上に `microbr` ブリッジを作成 (192.168.83.1/24)
- 全 VM の TAP インターフェースはこのブリッジに接続
- NAT (masquerade) で外部ネットワークにアクセス

### VM アドレス割り当て

| VM | IP アドレス | TAP ID | MAC アドレス |
|----|------------|--------|-------------|
| vm1 | 192.168.83.11 | microvm1 | 02:00:00:00:00:01 |
| vm2 | 192.168.83.12 | microvm2 | 02:00:00:00:00:02 |

### WebUI アクセス (DNAT)

- ホスト:8781 → VM1:8787 (TCP)
- ホスト:8782 → VM2:8787 (TCP)
- 開発中は Tailscale 経由、本番は Cloudflare Tunnel + Access
- いずれもホスト側で一元管理

### DNS

- 8.8.8.8 / 1.1.1.1 (Tailscale MagicDNS は不要のため)

## VM リソース

| 項目 | 値 |
|------|-----|
| vCPU | 2 |
| RAM | 2 GB |
| ハイパーバイザー | cloud-hypervisor |
| balloon | true (ホストが未使用 RAM を回収可能) |
| 永続ボリューム | var.img (8 GB) |
| swap | /var/swapfile (2 GB) — OOM 対策 |
| writableStoreOverlay | なし (VM 内で Nix ビルド不要) |

## ストレージ / データ永続化

### virtiofs 共有

| タグ | ホスト側パス | VM 側マウントポイント | 用途 |
|------|-------------|----------------------|------|
| ro-store | /nix/store | /nix/.ro-store | Nix ストア (読み取り専用) |
| hermes-home | vm-data/<vm>/hermes-home | /home/kpn-didy/.hermes | Hermes の状態 (永続化) |
| ssh-keys | vm-data/<vm>/ssh-host-keys | /etc/ssh/host-keys | SSH ホスト鍵 (永続化) |

### シークレット管理

- OpenCode Go API キー (`secrets/opencode-go-key`)
- ホスト上で `0600` パーミッションを厳守
- VM 内では `$OPENCODE_GO_API_KEY` として `~/.hermes/.env` に設定
- 将来: `microvm.credentialFiles` による systemd クレデンシャル注入に移行推奨

## Hermes Agent 設定

- provider: opencode-go
- デフォルトモデル: deepseek-v4-flash
- API キー: `OPENCODE_GO_API_KEY` → `~/.hermes/.env`
- OpenCode Go のサブスクリプション ($10/月) で GLM-5.2, Kimi K2.7 Code, Qwen3.7 Max, DeepSeek V4 Pro/Flash などのモデルにアクセス可能

## Hermes WebUI

- `fetchFromGitHub` でソース取得 (`nesquena/hermes-webui`)
- `buildEnv` + `makeWrapper` で PATH/PYTHONPATH を設定
- systemd --user service として起動 (port 8787)
- Hermes Agent をインプロセスで実行 (bootstrap.py 相当)

## セキュリティ

- VM 内ファイアウォール有効 (22/tcp, 8787/tcp のみ許可)
- VM 同士の通信は firewall で制限
- シークレットファイルはホスト上で `0600`
- NAT の内側でも VM 分離を確保
- `securityModel = "none"` の virtiofs 共有に注意 (パーミッション管理)

## 運用

### 起動

```bash
cd /home/kpn-didy/git_repositories/hermes-works
# 初回のみ: 事前準備
mkdir -p vm-data/vm1/hermes-home vm-data/vm1/ssh-host-keys
mkdir -p vm-data/vm2/hermes-home vm-data/vm2/ssh-host-keys
ssh-keygen -t ed25519 -N "" -f vm-data/vm1/ssh-host-keys/ssh_host_ed25519_key
ssh-keygen -t ed25519 -N "" -f vm-data/vm2/ssh-host-keys/ssh_host_ed25519_key
echo "sk-..." > secrets/opencode-go-key && chmod 0600 secrets/opencode-go-key

# ビルド&デプロイ
nixos-rebuild switch --flake .#kpn-didy-nixos

# VM 起動
sudo systemctl start microvm@vm1
sudo systemctl start microvm@vm2
```

### アクセス

```bash
# WebUI
open http://localhost:8781  # VM1
open http://localhost:8782  # VM2

# SSH
ssh kpn-didy@192.168.83.11  # VM1
ssh kpn-didy@192.168.83.12  # VM2
```

### 停止

```bash
sudo systemctl stop microvm@vm1
sudo systemctl stop microvm@vm2
```

## 注意点・制約

1. **nixos-rebuild switch で VM が再起動** — `restartIfChanged` がデフォルト true
   - Hermes がタスク実行中は中断される可能性あり
   - 必要に応じて `restartIfChanged = false` に設定可能
2. **cloud-hypervisor とカーネルの互換性** — `inputs.nixpkgs.follows` でバージョンスキュー回避
3. **Cachix サブスティテューター** — `microvm.cachix.org` の設定を推奨
4. **バックアップ** — `vm-data/` 以下の永続データは定期バックアップ推奨
5. **ログローテーション** — Hermes Agent のログが成長するため、journald のサイズ制限設定を推奨
