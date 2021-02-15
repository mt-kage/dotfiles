#!/bin/bash

readonly DOTFILES_DIR="$HOME/dotfiles"
readonly SCRIPT_DIR="$DOTFILES_DIR/scripts"
readonly GIT_REMOTE_ORIGIN="https://github.com/mt-kage/dotfiles.git"
readonly GIT_DEFAULT_BRANCH="master"


function exists_command() {
  type -a $1 >/dev/null 2>&1
}

function execute() {
    echo "[${SCRIPT_DIR}/${1}.sh] START"
    /bin/bash "${SCRIPT_DIR}/${1}.sh"
}

function download() {
  if [ -d ${DOTFILES_DIR} ]; then
    echo "Download dotfiles start."
    if exists_command "git"; then
      git pull ${GIT_REMOTE_ORIGIN} ${GIT_DEFAULT_BRANCH}
    else
      echo "ERROR: git required."
      exit 1
    fi
    echo "Download dotfiles end."
  else
    echo "ERROR: dotfiles required."
    exit 1
  fi
}

function update() {
  echo "           _        _                       __  _       _    __ _ _"
  echo " _ __ ___ | |_     | | ____ _  __ _  ___   / /_| | ___ | |_ / _(_) | ___  ___"
  echo "| '_ \` _ \\| __|____| |/ / _\` |/ _\` |/ _ \\ / / _\` |/ _ \\| __| |_| | |/ _ \\/ __|"
  echo "| | | | | | ||_____|   < (_| | (_| |  __// / (_| | (_) | |_|  _| | |  __/\\__ \\"
  echo "|_| |_| |_|\\__|    |_|\\_\\__,_|\\__, |\\___/_/ \\__,_|\\___/ \\__|_| |_|_|\\___||___/"
  echo "                              |___/"

  download

  cd ${DOTFILES_DIR}
  execute deploy
  echo "Update dotfiles success!"
}

update
