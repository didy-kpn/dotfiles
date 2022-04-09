# install
# sharkdp/bat, sharkdp/fd, BurntSushi/ripgrep, gitui

# About iTerm2
# https://github.com/mbadolato/iTerm2-Color-Schemes#installation-instructions
# color scheme = hybrid

# About Python module
# pip3 install --upgrade pip setuptools neovim pynvim
# pip3 install --upgrade mypy flake8 isort black autopep8

# About nvim-config
mkdir -p "${XDG_CONFIG_HOME}"/nvim
mkdir -p "${XDG_CONFIG_HOME}"/nvim/nvim
mkdir -p "${XDG_CONFIG_HOME}"/nvim/backup
mkdir -p "${XDG_CONFIG_HOME}"/nvim/swap
mkdir -p "${XDG_CONFIG_HOME}"/nvim/undo
mkdir -p "${XDG_CONFIG_HOME}"/nvim/sessions
mkdir -p "${XDG_CONFIG_HOME}"/nvim/pack/paqs/opt
git clone https://github.com/savq/paq-nvim "${XDG_CONFIG_HOME}"/nvim/pack/paqs/opt/paq-nvim

ln -s "${HOME}"/dotfiles/lua "${XDG_CONFIG_HOME}"/nvim/lua
ln -s "${HOME}"/dotfiles/init.lua "${XDG_CONFIG_HOME}"/nvim/init.lua
ln -s "${HOME}"/dotfiles/coc-settings.json "${XDG_CONFIG_HOME}"/nvim/coc-settings.json
