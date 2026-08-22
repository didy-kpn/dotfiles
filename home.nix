{ config, pkgs, lib, llm-agents, system, open-design, ... }:

{
  imports = [ open-design.homeManagerModules.default ];

  home.username = "kpn-didy";
  home.homeDirectory = "/home/kpn-didy";
  home.stateVersion = "25.11";

  # ----------------------------------------
  # パッケージ
  # ----------------------------------------
  home.packages = with pkgs; [
    # --- 基本ツール ---
    wget
    curl
    gh
    cloudflared
    gnumake
    gcc

    # --- CLI 代替 ---
    eza
    bat
    fd
    ripgrep
    fzf

    # --- プロンプト ---
    starship

    # --- 履歴検索 ---
    atuin

    # --- その他 ---
    zoxide
    carapace
    sheldon
    yazi

    # --- ターミナルマルチプレクサ ---
    zellij

    # --- microVM ---
    microsandbox

    # --- Git TUI ---
    lazygit

    # --- 開発言語 (PHP) ---
    php
    phpunit
    php82Packages.composer
    phpstan

    # --- 開発言語 (Go) ---
    go
    gopls

    # --- 開発言語 (Rust) ---
    rustc
    cargo
    rust-analyzer

    # --- 開発言語 (Python) ---
    python3
    pyright

    # --- 開発言語 (Node.js) ---
    nodejs
    pnpm

    # --- エディタ ---
    neovim

    # --- DB ---
    sqlite
    bubblewrap
    socat
  ] ++ (with llm-agents.packages.${system}; [
    pi
    opencode
    sandbox-runtime
    herdr
    hermes-agent
    backlog-md
    qmd
  ]);

  # chezmoi の dot_zshrc / dot_zshenv を ~/.zshrc / ~/.zshenv に展開
  home.file = {
    ".zshrc".source = ./dot_zshrc;
    ".zshenv".source = ./dot_zshenv;
  };

  # nvim 設定ファイルは従来の dot_config/nvim をそのまま参照
  xdg.configFile."nvim" = {
    source = ./dot_config/nvim;
    recursive = true;
  };

  xdg.configFile."zellij/config.kdl" = {
    source = ./dot_config/zellij/config.kdl;
  };

  xdg.configFile."sheldon/plugins.toml" = {
    source = ./dot_config/sheldon/plugins.toml;
  };

  # ----------------------------------------
  # Git
  # ----------------------------------------
  programs.git = {
    enable = true;
    settings = {
      user.name = "didy";
      user.email = "9417799+didy-kpn@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ----------------------------------------
  # direnv (任意)
  # ----------------------------------------
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # ----------------------------------------
  # Open Design (デザインエージェント)
  # ----------------------------------------
  services.open-design = {
    enable = true;
    autoStart = true;
    webFrontend = {
      enable = true;
      # 0.0.0.0 は Caddy では Host matcher になるため、空で全 Host を受ける
      host = "";
      allowedOrigins = [
        "http://100.70.91.62:5174"
        "http://kpn-didy-nixos.tail7c0eff.ts.net:5174"
      ];
    };
  };
}
