#!/bin/bash

function echo_info() {
    printf "\e[37;42;1m${1}\e[m\n\n"
}

function echo_warning() {
    printf "\e[37;43;4m${1}\e[m\n\n"
}

DOTPATH=$(dirname $(cd $(dirname $0); pwd))

cd "$DOTPATH" || exit 1

echo_info "copy start..."

for file in .??*; do
    [[ "$file" = ".git" ]] && continue
    [[ "$file" = ".DS_Store" ]] && continue
    [[ "$file" = ".travis.yml" ]] && continue
    ln -fvns "$DOTPATH/$file" "$HOME/$file"
done

echo_info "copy end!"
