#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

readonly GIT_REMOTE_HTTPS_URL="https://github.com/mt-kage/dotfiles.git"
readonly GIT_REMOTE_SSH_URL="git@github.com:mt-kage/dotfiles.git"
readonly GIT_REMOTE_NAME="origin"
readonly GIT_DEFAULT_BRANCH="main"

initialize_brew() {
  if exists_command "brew"; then
    log_info "brew already exists. install skipped."
  else
    log_info "installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if is_macos; then
    if is_arm && [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  elif is_linux; then
    if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
      eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    fi
  fi

  log_info "initialize brew..."
  brew doctor || true
  brew update
  brew upgrade
  brew bundle
  brew cleanup -s

  log_success "initialize brew"
}

initialize_dotfiles() {
  log_info "initialize dotfiles..."
  git init
  git remote add "${GIT_REMOTE_NAME}" "${GIT_REMOTE_HTTPS_URL}"
  git add .
  git checkout .
  git pull "${GIT_REMOTE_NAME}" "${GIT_DEFAULT_BRANCH}"
  git remote set-url "${GIT_REMOTE_NAME}" "${GIT_REMOTE_SSH_URL}"
  log_success "initialize dotfiles"
}

initialize_macos() {
  if ! is_macos; then
    log_warn "not macOS. skipped."
    return
  fi

  log_info "initialize macos..."

  # remove localized file
  rm -f ~/Applications/.localized
  rm -f ~/Documents/.localized
  rm -f ~/Downloads/.localized
  rm -f ~/Desktop/.localized
  rm -f ~/Public/.localized
  rm -f ~/Pictures/.localized
  rm -f ~/Music/.localized
  rm -f ~/Movies/.localized
  rm -f ~/Library/.localized
  rm -f /Applications/.localized

  # mkdir
  mkdir -p ~/Projects
  mkdir -p ~/Pictures/Screenshots

  # screenshot settings
  defaults write com.apple.screencapture name "Screenshot"
  defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots"
  defaults write com.apple.screencapture show-thumbnail -bool false
  defaults write com.apple.screencapture save-selections -bool false

  # sort launchpad
  defaults write com.apple.dock ResetLaunchPad -bool true
  killall Dock

  log_success "initialize macos"
}

initialize_wsl() {
  if ! is_wsl; then
    log_warn "not WSL. skipped."
    return
  fi

  log_info "initialize wsl..."

  # Install required packages on Ubuntu / Debian for Linuxbrew and build dependencies
  if is_ubuntu; then
    log_info "installing apt packages (build-essential, mise build dependencies, wslu)..."
    sudo apt-get update -y
    sudo apt-get install -y \
      build-essential \
      procps \
      curl \
      file \
      git \
      zsh \
      wslu \
      libssl-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      libffi-dev \
      liblzma-dev
  fi

  # mkdir
  mkdir -p ~/Projects

  # Configure Git Credential Manager for Windows if present
  local gcm_path="/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe"
  if [[ -f "${gcm_path}" ]]; then
    log_info "Configuring Git Credential Manager for Windows..."
    git config --global credential.helper "${gcm_path}"
  fi

  log_success "initialize wsl"
}

initialize() {
  log_info "initialize start."

  initialize_macos
  initialize_wsl

  initialize_brew
  initialize_dotfiles
  log_success "initialize complete!"
}

initialize
