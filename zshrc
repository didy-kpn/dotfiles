#
# 環境設定
export EDITOR=nvim
export LANG=ja_JP.UTF-8
export TERM=xterm-256color

export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

export XDG_CONFIG_HOME=$HOME/.config

# nodejsの環境パスを通す
export PATH=$HOME/.nodebrew/current/bin:$PATH

# zplug 初期設定
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

export PATH=$HOME/.local/share/solana/install/active_release/bin:$PATH

# rbenvにパスを通す
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"

# viライクな操作
bindkey -v

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 履歴に重複したコマンドがある場合は古い方を削除
setopt hist_save_nodups

# 同じコマンドを履歴に保存しない
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# スペースから始まるコマンドは保存しない
setopt hist_ignore_space

# 履歴に保存するときに余分なスペースを削除
setopt hist_reduce_blanks

# リアルタイムで履歴を共有する
setopt share_history

# 色の有効
autoload -Uz colors
colors

# 補完有効
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# cdを使わずディレクトリ移動
setopt auto_cd
alias ...='cd ../../'
alias ....='cd ../../../'

# cd移動先をスタックに追加'cd +<Tab>'
setopt auto_pushd
setopt pushd_ignore_dups

# beepを無効
setopt no_beep

# neovimで開く
alias vim='nvim'

# vimで新規ファイルを開くときタブで開く
alias mvim='mvim --remote-tab-silent'

# alias設定
# if [ -x "`which peco`" ]; then
#   alias tp='top | peco'
#   alias pp='ps aux | peco'
# fi

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias -g L='| less'
alias -g G='| grep'
alias -g P='| peco'

# 再読み込み
alias reload='source ~/.zshrc'

# TODO zshプラグイン
zplug "plugins/git",  from:oh-my-zsh
zplug "plugins/git-flow",  from:oh-my-zsh
zplug "plugins/brew",  from:oh-my-zsh
zplug "plugins/vi-mode",  from:oh-my-zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"

# zshプラグインの設定
if ! zplug check --verbose; then
  zplug install
fi

zplug load --verbose

autoload -Uz vcs_info
setopt prompt_subst

precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# TODO
PROMPT=" %{${fg[green]}%}%~%{${reset_color}%} %F{blue}%1v%f
> "

# fzf読み込み
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# gcloudの補完
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
