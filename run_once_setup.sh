#!/usr/bin/env bash
set -euo pipefail

log() {
  printf "[setup] %s\n" "$1"
}

install_xcode_select() {
  if command -v xcode-select >/dev/null 2>&1; then
    return 0
  fi
  log "Xcode Select Installing..."
  xcode-select --install
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi
  log "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_devbox() {
  if command -v devbox >/dev/null 2>&1; then
    return 0
  fi
  log "devbox not found. Installing..."
  curl -fsSL https://get.jetify.com/devbox | bash
}

install_nix() {
  if command -v nix >/dev/null 2>&1 ||
    [ -x /nix/var/nix/profiles/default/bin/nix ] ||
    [ -x "$HOME/.nix-profile/bin/nix" ]; then
    return 0
  fi
  log "nix not found. Installing..."
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install
}

install_xcode_select
install_homebrew
install_devbox
install_nix

if command -v brew >/dev/null 2>&1; then
  log "Installing casks from Brewfile..."
  brew bundle --global
else
  log "brew not available; skipping Brewfile install."
fi

log "Setup finished. Please reload your shell or restart your terminal session."
