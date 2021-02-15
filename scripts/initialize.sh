#!/bin/bash

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

  echo "initialize brew..."
  brew doctor
  brew update
  brew upgrade
  brew bundle
  brew cleanup -s

  echo "initialize brew success!"
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
  initialize_anyenv
  initialize_macos

  echo "initialize success!"
}

initialize
