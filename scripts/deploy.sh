#!/bin/bash

readonly DOTFILES_DIR="$(dirname $(cd $(dirname $0); pwd))/configs"

function deploy_settings() {
  echo "deploy settings start..."
  cd ${DOTFILES_DIR} || exit 1
  for file in .??*; do
      [[ "$file" = ".git" ]] && continue
      [[ "$file" = ".DS_Store" ]] && continue
      echo "deploy file.[$DOTFILES_DIR/$file => $HOME/$file]"
      ln -fvns "$DOTFILES_DIR/$file" "$HOME/$file"
  done

  echo "deploy settings success!"
}

function deploy() {
  echo "deploy start."
  deploy_settings

  source ~/.bashrc
  echo "deploy success!"
}

deploy
