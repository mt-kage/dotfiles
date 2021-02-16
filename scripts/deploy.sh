#!/bin/bash

readonly DOTFILES_DIR="$(dirname $(cd $(dirname $0); pwd))"
readonly CONFIGS_DIR="$DOTFILES_DIR/configs"
readonly VIM_DIR="$DOTFILES_DIR/vim"
readonly KARAVINER_DIR="$DOTFILES_DIR/karabiner"

function deploy_configs() {
  echo "deploy configs start..."
  cd ${CONFIGS_DIR} || exit 1
  for file in .??*; do
      [[ "$file" = ".git" ]] && continue
      [[ "$file" = ".DS_Store" ]] && continue
      ln -fvns "$CONFIGS_DIR/$file" "$HOME/$file"
  done

  echo "deploy configs success!"
}

function deploy_vim() {
  echo "deploy vim start..."
  ln -fvns ${VIM_DIR} "$HOME/.vim"
  echo "deploy vim success!"
}

function deploy_karabiner() {
  echo "deploy karabiner start..."
  ln -fvns "$KARAVINER_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
  echo "deploy karabiner success!"
}


function deploy() {
  echo "deploy start."
  deploy_configs
  deploy_vim
  deploy_karabiner

  source ~/.bashrc
  echo "deploy success!"
}

deploy
