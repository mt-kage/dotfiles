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

formulas=(
    git
    wget
    curl
    tree
    openssl
    colordiff
    cask
    peco
    hub
    lua
    "vim --with-lua"
    ssh-copy-id
    diff-so-fancy
    thefuck
    cowsay
    anyenv
    gibo
    jq
    protobuf
    sl
)

echo_info "start brew install apps..."
for formula in "${formulas[@]}"; do
    if type $formula > /dev/null 2>&1; then
        echo_warning "[${formula}] already exists."
    else
        brew install $formula || brew upgrade $formula
    fi
done

casks=(
    firefox
    google-chrome
    google-japanese-ime
    google-drive
    slack
    funter
    refresh-finder
    1password
    iterm2
    cyberduck
    intellij-idea
    atom
    visual-studio-code
    sourcetree
    dockertoolbox
    virtualbox
    vagrant
    vagrant-manager
)

echo_info "start brew cask install apps..."
for cask in "${casks[@]}"; do
    if type $formula > /dev/null 2>&1; then
        echo_warning "[${cask}] already exists."
    else
        brew cask install $cask
    fi

done

echo_info "run brew cleanup..."
brew cleanup -s

echo_info "
**************************************************
               HOMEBREW INSTALLED!
**************************************************"
