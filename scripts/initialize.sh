#!/bin/bash

function echo_info() {
    printf "\e[37;42;1m${1}\e[m\n\n"
}

function echo_warning() {
    printf "\e[37;43;4m${1}\e[m\n\n"
}

echo_info "installing homebrew..."
which brew >/dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo_info "run brew doctor..."
which brew >/dev/null 2>&1 && brew doctor

echo_info "run brew update..."
which brew >/dev/null 2>&1 && brew update

echo_info "run brew upgrade..."
brew upgrade

echo_info "run brew bundle..."
brew bundle

echo_info "run brew cleanup..."
brew cleanup -s

echo_info "
**************************************************
               HOMEBREW INSTALLED!
**************************************************"
