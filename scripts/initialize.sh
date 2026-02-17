#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"

readonly GIT_REMOTE_HTTPS_URL="https://github.com/mt-kage/dotfiles.git"
readonly GIT_REMOTE_SSH_URL="git@github.com:mt-kage/dotfiles.git"
readonly GIT_REMOTE_NAME="origin"
readonly GIT_DEFAULT_BRANCH="master"

initialize_brew() {
  if exists_command "brew"; then
    log_info "brew already exists. install skipped."
  else
    log_info "installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if is_arm; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  log_info "initialize brew..."
  brew doctor
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

initialize_anyenv() {
  if exists_command "anyenv"; then
    log_info "initialize anyenv..."
    anyenv init
    log_success "initialize anyenv"
  else
    log_warn "anyenv not found. skipped."
  fi
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

initialize() {
  log_info "initialize start."
  initialize_brew
  initialize_dotfiles
  initialize_anyenv
  initialize_macos
  log_success "initialize complete!"
}

initialize
