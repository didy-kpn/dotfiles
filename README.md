# dotfiles

NixOS (`izm-home-nixos`) のシステム設定とユーザー環境を Flake + Home Manager で管理します。

## 前提

- NixOS 25.11 (Xantusia)
- Flake 有効 (`experimental-features = nix-command flakes`)

## ディレクトリ構成

```
.
├── flake.nix                        # Flake エントリポイント
├── flake.lock                       # 自動生成
├── home.nix                         # Home Manager: ユーザー環境
├── hosts/
│   └── izm-home-nixos/
│       ├── default.nix              # システム設定
│       └── hardware-configuration.nix  # 自動生成（編集禁止）
├── dot_config/
│   ├── nvim/                        # Neovim 設定（LazyVim 構成）
│   ├── zellij/config.kdl            # Zellij 設定
│   └── sheldon/plugins.toml         # Sheldon プラグイン定義
└── PLANS/
    └── nixos-migration.md           # 移行計画
```

## セットアップ

### NixOS への適用（初回のみ）

1. 設定を適用する
   ```bash
   sudo nixos-rebuild switch --flake ~/dotfiles#izm-home-nixos
   ```

2. 再ログインまたはシェルを再読み込み
   ```bash
   exec zsh
   ```

## 日常的な操作

### 設定変更後にシステムに反映する

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#izm-home-nixos
```

### 設定の構文チェックのみ行う（適用はしない）

```bash
nix flake check
```

### 依存関係を更新する

```bash
nix flake update
```

### 特定の input だけ更新する

```bash
nix flake update home-manager
nix flake update llm-agents
```

### ゴミを掃除する（古い世代を削除）

```bash
sudo nix-collect-garbage --delete-older-than 14d
```

## 含まれるツール

### システム管理
- cloudflared（Cloudflare Tunnel 経由で SSH 公開）
- openssh（公開鍵認証のみ、パスワード認証無効）

### CLI ツール
- zsh + sheldon（プラグイン管理）+ starship（プロンプト）
- zoxide（cd 代替）、atuin（履歴検索）、carapace（補完）
- eza（ls 代替）、bat（cat 代替）、fd（find 代替）、ripgrep（grep 代替）
- fzf（ファジーファインダー）、zellij（ターミナルマルチプレクサ）

### 開発ツール
- Neovim（LazyVim 構成、LSP / Treesitter / DAP 対応）
- PHP（php, composer, phpunit, phpstan）
- Go（go, gopls）
- Rust（rustc, cargo, rust-analyzer）
- Python（python3, pyright）
- Node.js（nodejs）
- lazygit（Git TUI）
- pi / opencode（AI エージェント, llm-agents.nix 経由）

### Git
- git + gh（GitHub CLI）

# License

This project is licensed under the MIT License.

See [LICENSE](https://github.com/didy-kpn/dotfiles/blob/master/LICENSE) for details.
