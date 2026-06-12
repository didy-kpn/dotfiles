{ config, pkgs, lib, llm-agents, system, ... }:

{
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

    # --- CLI 代替 ---
    eza
    bat
    fd
    ripgrep
    fzf

    # --- ターミナルマルチプレクサ ---
    zellij

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
  ] ++ (with llm-agents.packages.${system}; [
    pi
    opencode
  ]);

  # ----------------------------------------
  # シェル設定 (zsh)
  # ----------------------------------------
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    # dot_zshenv 相当の環境変数
    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      TERM = "xterm-256color";
      XDG_CONFIG_HOME = "$HOME/.config";
    };

    # zshrc 本体（chezmoi の dot_zshrc から移植）
    initContent = ''
      export PATH=$HOME/.local/bin:$PATH
      export PATH=$HOME/.cargo/bin:$PATH
    '' + ''
      # git gtr completion
      if command -v git-gtr >/dev/null 2>&1; then
        git_gtr_bin=$(command -v git-gtr)
        git_gtr_root=''${git_gtr_bin:h:h}
        git_gtr_completions="''${git_gtr_root}/completions"
        if [[ -d "''${git_gtr_completions}" ]]; then
          fpath=("''${git_gtr_completions}" $fpath)
        fi
      fi
      zstyle ':completion:*:*:git:*' user-commands gtr:'Git worktree management'

      # completion system
      autoload -U compinit && compinit

      # zellij auto-start
      if command -v zellij >/dev/null 2>&1; then
        eval "$(zellij setup --generate-auto-start zsh)"
      fi

      # carapace
      if command -v carapace >/dev/null 2>&1; then
        export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
        zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
        source <(carapace _carapace zsh)
      fi

      autoload -Uz _git
      compdef _git git

      if [[ -n "''${git_gtr_completions:-}" && -r "''${git_gtr_completions}/_git-gtr" ]]; then
        autoload -Uz _git-gtr
        compdef _git-gtr git-gtr
      fi

      # エイリアス
      if command -v abbr >/dev/null 2>&1; then
        {
          abbr add --session --quiet --force ...='cd ../../'
          abbr add --session --quiet --force ....='cd ../../../'
          abbr add --session --quiet --force ll='eza --icons -lah'
          abbr add --session --quiet --force llt='eza --icons -lah -T -L2'
          abbr add --session --quiet --force rm='rm -i'
          abbr add --session --quiet --force cp='cp -i'
          abbr add --session --quiet --force mv='mv -i'
          abbr add --session --quiet --force mkdir='mkdir -p'
          abbr add --session --global --quiet --force L='| less'
          abbr add --session --global --quiet --force G='| grep'
          abbr add --session --global --quiet --force P='| fzf'
          abbr add --session --quiet --force reload='source ~/.zshrc'
          abbr add --session --quiet --force ls='eza --icons'
          abbr add --session --quiet --force vim='nvim'
          abbr add --session --quiet --force cat='bat'
          abbr add --session --quiet --force find='fd'
          abbr add --session --quiet --force grep='rg'
        } >/dev/null 2>&1
      fi

      # vi ライク操作
      bindkey -v

      # 履歴設定
      HISTFILE=~/.zsh_history
      HISTSIZE=1000000
      SAVEHIST=1000000
      setopt hist_save_nodups
      setopt hist_ignore_dups
      setopt hist_ignore_all_dups
      setopt hist_ignore_space
      setopt hist_reduce_blanks
      setopt share_history
      setopt auto_cd
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt no_beep
    '';

    # sheldon で管理しているプラグインは sheldon 経由で読み込む
    # (programs.sheldon の設定参照)
    localVariables = {
      ZDOTDIR = "$HOME";
    };
  };

  # ----------------------------------------
  # sheldon (zsh プラグインマネージャ)
  # ----------------------------------------
  programs.sheldon = {
    enable = true;
    settings = {
      shell = "zsh";
    };
    # plugins.toml を source から読み込む
    # 従来の dot_config/sheldon/plugins.toml をそのまま使う
  };

  # ----------------------------------------
  # starship (プロンプト)
  # ----------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # ----------------------------------------
  # zoxide (cd 代替)
  # ----------------------------------------
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ----------------------------------------
  # atuin (履歴検索)
  # ----------------------------------------
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # ----------------------------------------
  # carapace (補完)
  # ----------------------------------------
  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  # ----------------------------------------
  # Neovim
  # ----------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # nvim 設定ファイルは従来の dot_config/nvim をそのまま参照
  xdg.configFile."nvim" = {
    source = ./dot_config/nvim;
    recursive = true;
  };

  # ----------------------------------------
  # Zellij
  # ----------------------------------------
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # config.kdl の内容を Home Manager の settings で直接記述するか、
      # 従来の設定ファイルを参照するか選択可能
      # ここでは xdg.configFile で従来ファイルを参照
    };
  };

  xdg.configFile."zellij/config.kdl" = {
    source = ./dot_config/zellij/config.kdl;
  };

  # ----------------------------------------
  # Git
  # ----------------------------------------
  programs.git = {
    enable = true;
    settings = {
      user.name = "kpn-didy";
      user.email = "kpn.didy@gmail.com";
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
}
