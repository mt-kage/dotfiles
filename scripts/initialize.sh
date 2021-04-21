#!/bin/bash

readonly GIT_REMOTE_HTTPS_URL="https://github.com/mt-kage/dotfiles.git"
readonly GIT_REMOTE_SSH_URL="git@github.com:mt-kage/dotfiles.git"
readonly GIT_REMOTE_NAME="origin"
readonly GIT_DEFAULT_BRANCH="master"
readonly UNAME=`uname -m`

function is_arm() {
  test "$UNAME" == "arm64";
}

function exists_command() {
  type -a $1 >/dev/null 2>&1
}

function initialize_brew() {
  if exists_command "brew"; then
    echo "brew already exists. install skipped."
  else
    echo "installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if is_arm; then
    /opt/homebrew/bin/brew shellenv
  else
    /usr/local/bin/brew shellenv
  fi
  brew shellenv > ~/.path

  echo "initialize brew..."
  brew doctor
  brew update
  brew upgrade
  brew bundle
  brew cleanup -s

  echo "initialize brew success!"
}

function initialize_dotfiles() {
  git init
  git remote add ${GIT_REMOTE_NAME} ${GIT_REMOTE_HTTPS_URL}
  git add .
  git checkout .
  git pull ${GIT_REMOTE_NAME} ${GIT_DEFAULT_BRANCH}
  git remote set-url ${GIT_REMOTE_NAME} ${GIT_REMOTE_SSH_URL}
}

function initialize_anyenv() {
  if exists_command "anyenv"; then
    echo "initialize anyenv..."
    anyenv init
    echo "initialize anyenv success!"
  else
    echo "ERROR: anyenv required."
    exit 1
  fi
}

function initialize_macos() {
  echo "initialize macos..."
  # remove localized file
  rm ~/Applications/.localized
  rm ~/Documents/.localized
  rm ~/Downloads/.localized
  rm ~/Desktop/.localized
  rm ~/Public/.localized
  rm ~/Pictures/.localized
  rm ~/Music/.localized
  rm ~/Movies/.localized
  rm ~/Library/.localized
  rm /Applications/.localized

  # mkdir
  mkdir ~/Projects
  mkdir ~/Pictures/Screenshots

  # screenshot settings
  defaults write com.apple.screencapture name "Screenshot"
  defaults write com.apple.screencapture location "~/Pictures/Screenshots"
  defaults write com.apple.screencapture show-thumbnail -bool false
  defaults write com.apple.screencapture save-selections -bool false

  # default shell
  chsh -s /bin/bash

  # sort launchpad
  defaults write com.apple.dock ResetLaunchPad -bool true
  killall Dock

  echo "initialize macos success!"
}

function initialize() {
  echo "initialize start."
  initialize_brew
  initialize_dotfiles
  initialize_anyenv
  initialize_macos

  echo "initialize success!"
}

initialize
