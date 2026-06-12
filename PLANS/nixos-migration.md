# NixOS Dotfiles 移行計画 (chezmoi → Flake + Home Manager)

## 目的

現在 macOS 向けに chezmoi で管理している dotfiles (`~/dotfiles`) を、NixOS (`izm-home-nixos`) のシステム設定として Flake + Home Manager で統一的に管理する。最終的に `~/dotfiles` が NixOS の設定と個人用アプリケーション設定の唯一のソースとなることを目指す。

## 現状

| 項目 | 状態 |
|------|------|
| OS | NixOS 25.11 (Xantusia), x86_64-linux |
| ホスト名 | `izm-home-nixos` |
| ユーザー | `kpn-didy` (uid=1000, groups: wheel, networkmanager) |
| 既存設定 | `/etc/nixos/configuration.nix`, `/etc/nixos/hardware-configuration.nix` |
| dotfiles | `~/dotfiles` (chezmoi 形式: macOS 用。alacritty/ghostty/nvim/mise/rio/sheldon/zellij の設定) |
| chezmoi | **未インストール** (NixOS 上ではまだ使っていない) |
| Flake | experimental-features は有効 (`nix-command` `flakes`) |
| Home Manager | **未導入** |
| パッケージ管理 | `environment.systemPackages` に vim/git/wget/curl/cloudflared/gh |

## 決定事項 (ユーザー判断反映済み)

| # | 項目 | 決定 |
|---|------|------|
| 1 | pi + opencode | Home Manager 経由 (llm-agents.nix)。git, gh, cloudflared も Home Manager へ移行 |
| 2 | nvim PHP 関連プラグイン | そのまま維持（発動条件が揃わなければ無害） |
| 3 | lazygit | 導入する |
| 4 | mise | 不導入（nixpkgs / llm-agents.nix で代替） |
| 5 | 開発言語 (PHP, Go, Rust, Python, Node) | nixpkgs からすべて導入 |
| 6 | carapace | 導入する |

## 導入判断リスト（確定版）

### 📦 パッケージ

| ツール | 管理方法 | 備考 |
|--------|---------|------|
| git | Home Manager | `programs.git` で設定も管理 |
| gh | Home Manager | |
| cloudflared | Home Manager + system設定 | バイナリは HM、サービス定義は system |
| vim → nvim | Home Manager | `programs.neovim` |
| wget, curl | Home Manager | |
| zsh | Home Manager | `programs.zsh` |
| sheldon | Home Manager | `programs.sheldon` |
| zellij | Home Manager | `programs.zellij` |
| eza, bat, fd, ripgrep | Home Manager | CLI 代替ツール |
| zoxide | Home Manager | `programs.zoxide` |
| atuin | Home Manager | zsh 履歴検索 |
| starship | Home Manager | `programs.starship` |
| carapace | Home Manager | zsh 補完 |
| fzf | Home Manager | |
| lazygit | Home Manager | |
| pi | Home Manager (llm-agents.nix) | |
| opencode | Home Manager (llm-agents.nix) | |
| php, phpunit, composer, phpstan | nixpkgs (Home Manager) | nvim プラグイン維持のため |
| go + gopls | nixpkgs (Home Manager) | |
| rust + rust-analyzer | nixpkgs (Home Manager) | |
| python + pyright | nixpkgs (Home Manager) | |
| node + npm | nixpkgs (Home Manager) | |

### 🔧 設定ファイル

| 設定ファイル | 判断 | 扱い |
|-------------|------|------|
| dot_zshrc | ✅ 導入（調整必要） | devbox global shellenv 削除、HM の programs.zsh に統合 |
| dot_zshenv | ✅ 導入（調整必要） | macOS パス削除、EDITOR / XDG_CONFIG_HOME 維持 |
| dot_config/nvim/ | ✅ 導入（そのまま） | xdg.configFile で管理、PHP 設定も維持 |
| dot_config/zellij/config.kdl | ✅ 導入 | programs.zellij で管理 |
| dot_config/sheldon/plugins.toml | ✅ 導入 | programs.sheldon で管理 |
| alacritty.toml | ❌ 不導入 | サーバー用途では不要 |
| ghostty/config | ❌ 不導入 | macOS 専用 |
| rio/config.toml | ❌ 不導入 | 同上 |
| mise/config.toml | ❌ 不導入 | mise 不要のため |
| dot_Brewfile | ❌ 不導入 | macOS 専用 |
| run_once_setup.sh | ❌ 不導入 | macOS + devbox 用 |
| private_dot_local/ | ❌ 不導入 | devbox 生成ファイル |

### 📋 NixOS システム設定

| ファイル | 状態 | 役割 |
|---------|------|------|
| hosts/izm-home-nixos/default.nix | ✅ コピー済み | システム設定全般 |
| hosts/izm-home-nixos/hardware-configuration.nix | ✅ コピー済み | 自動生成、編集禁止 |

## 全体アーキテクチャ（目標）

```
~/dotfiles/
├── flake.nix              # Flake エントリポイント
├── flake.lock             # ロックファイル (自動生成)
├── home.nix               # Home Manager: ユーザー環境全般
├── home/
│   ├── cli.nix            # CLI ツール (eza, bat, fd, rg, zoxide, atuin, carapace, fzf)
│   ├── dev.nix            # 開発ツール (PHP, Go, Rust, Python, Node, lazygit)
│   ├── editors.nix        # エディタ (neovim)
│   ├── shell.nix          # シェル設定 (zsh, sheldon, starship)
│   └── llm.nix            # pi, opencode (llm-agents.nix)
├── hosts/
│   └── izm-home-nixos/
│       ├── default.nix    # ホスト固有設定 (ハードウェア、ネットワーク、サービス)
│       ├── hardware-configuration.nix  # ハードウェア自動生成
│       └── services.nix   # デーモン系 (openssh, cloudflared)
├── dot_config/            # 従来の chezmoi 設定ファイル (Live 参照)
│   ├── nvim/              # そのまま維持
│   ├── zellij/            # programs.zellij 経由
│   └── sheldon/           # programs.sheldon 経由
```

## 移行ステップ

### Phase 0: 下準備 ✅ 完了
- [x] `~/dotfiles/hosts/izm-home-nixos/` 作成
- [x] `default.nix` と `hardware-configuration.nix` をコピー

### Phase 1: /etc/nixos → ~/dotfiles 移動と Flake 化 ✅ 完了
- [x] `default.nix` (旧 configuration.nix) をコピー
- [x] `hardware-configuration.nix` をコピー
- [ ] `flake.nix` を作成 ← **次**
- [ ] `sudo nixos-rebuild switch --flake ~/dotfiles#izm-home-nixos` で動作確認

### Phase 2: Home Manager の導入
- [ ] flake.nix に Home Manager input 追加
- [ ] `home.nix` 作成
  - [ ] zsh 設定 (sheldon, starship, zoxide, atuin, carapace)
  - [ ] neovim (xdg.configFile)
  - [ ] zellij (programs.zellij)
  - [ ] CLI ツール群
  - [ ] 開発言語群
  - [ ] pi + opencode (llm-agents.nix)
- [ ] `sudo nixos-rebuild switch` で反映確認

### Phase 3: dot_config の移行 & zshrc/zshenv の調整
- [ ] dot_zshrc → programs.zsh に統合 (devbox 関連削除)
- [ ] dot_zshenv → home.sessionVariables に統合 (macOS パス削除)
- [ ] dot_config/nvim → xdg.configFile で管理
- [ ] dot_config/zellij → programs.zellij で管理
- [ ] dot_config/sheldon → programs.sheldon で管理

### Phase 4: クリーンアップ
- [ ] 古い macOS 用ファイル (run_once_setup.sh, dot_Brewfile, PLANS/dotfiles-refresh.md) をアーカイブ
- [ ] README.md を NixOS 管理用に書き換え
- [ ] `sudo nix flake check` で整合性確認

## 注意点

1. **llm-agents.nix**: `inputs.llm-agents.packages.${system}.pi` / `.opencode` でアクセス
2. **ハードウェア設定**: `hardware-configuration.nix` は自動生成、編集禁止
3. **コンフリクト回避**: programs.zsh と dot_zshrc の移行は段階的に
4. **chezmoi 併存**: 移行期間中は chezmoi 設定を残し、HM から source 参照

## 参考リンク

- [NixOS Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix)
