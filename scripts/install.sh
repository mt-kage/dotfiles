#!/bin/bash

readonly DOTFILES_DIR="$HOME/dotfiles"
readonly SCRIPT_DIR="$DOTFILES_DIR/scripts"
readonly GIT_REPOSITORY_URL="https://github.com/mt-kage/dotfiles.git"
readonly GIT_DEFAULT_BRANCH="master"
readonly ARCHIVE_FILE="$GIT_DEFAULT_BRANCH.tar.gz"
readonly ARCHIVE_URL="https://github.com/mt-kage/dotfiles/archive/$ARCHIVE_FILE"


function exists_command() {
  type -a $1 >/dev/null 2>&1
}

function execute() {
    echo "[${SCRIPT_DIR}/${1}.sh] START"
    /bin/bash "${SCRIPT_DIR}/${1}.sh"
}

function download() {
  if [ ! -d ${DOTFILES_DIR} ]; then
    echo "Download dotfiles start."
    if exists_command "git"; then
      echo "use git."
      git clone ${GIT_REPOSITORY_URL} ${DOTFILES_DIR}
    elif exists_command "curl" || exists_command "wget"; then
      if exists_command "curl"; then
        echo "use curl."
        curl -L ${ARCHIVE_URL} -o ${ARCHIVE_FILE}
      else
        echo "use wget."
        wget ${ARCHIVE_URL}
      fi
      tar -zxvf ${ARCHIVE_FILE}
      rm -f ${ARCHIVE_FILE}
      mv -f dotfiles-${GIT_DEFAULT_BRANCH} ${DOTFILES_DIR}
    else
      echo "ERROR: curl or wget or git required."
      exit 1
    fi
    echo "Download dotfiles end."
  else
    echo "ERROR: dotfiles already exists."
    exit 1
  fi
}

function install() {
  echo "           _        _                       __  _       _    __ _ _"
  echo " _ __ ___ | |_     | | ____ _  __ _  ___   / /_| | ___ | |_ / _(_) | ___  ___"
  echo "| '_ \` _ \\| __|____| |/ / _\` |/ _\` |/ _ \\ / / _\` |/ _ \\| __| |_| | |/ _ \\/ __|"
  echo "| | | | | | ||_____|   < (_| | (_| |  __// / (_| | (_) | |_|  _| | |  __/\\__ \\"
  echo "|_| |_| |_|\\__|    |_|\\_\\__,_|\\__, |\\___/_/ \\__,_|\\___/ \\__|_| |_|_|\\___||___/"
  echo "                              |___/"

  download

#  execute initialize
#  execute deploy
  echo "Install dotfiles success!"
}

install
