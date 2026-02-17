#!/usr/bin/env bash
set -euo pipefail

readonly DOTFILES_DIR="$HOME/dotfiles"
readonly SCRIPT_DIR="$DOTFILES_DIR/scripts"
readonly GIT_DEFAULT_BRANCH="master"
readonly ARCHIVE_FILE="${GIT_DEFAULT_BRANCH}.tar.gz"
readonly ARCHIVE_URL="https://github.com/mt-kage/dotfiles/archive/${ARCHIVE_FILE}"

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info()    { 
  echo -e "${BLUE}[INFO]${NC} $*";
}

log_success() { 
  echo -e "${GREEN}[OK]${NC} $*";
}

log_error()   { 
  echo -e "${RED}[ERROR]${NC} $*" >&2;
}

exists_command() {
  type -a "$1" >/dev/null 2>&1; 
}

execute() {
  log_info "[${SCRIPT_DIR}/${1}.sh] START"
  /bin/bash "${SCRIPT_DIR}/${1}.sh"
}

show_banner() {
  echo "           _        _                       __  _       _    __ _ _"
  echo " _ __ ___ | |_     | | ____ _  __ _  ___   / /_| | ___ | |_ / _(_) | ___  ___"
  echo "| '_ \` _ \\| __|____| |/ / _\` |/ _\` |/ _ \\ / / _\` |/ _ \\| __| |_| | |/ _ \\/ __|"
  echo "| | | | | | ||_____|   < (_| | (_| |  __// / (_| | (_) | |_|  _| | |  __/\\__ \\"
  echo "|_| |_| |_|\\__|    |_|\\_\\__,_|\\__, |\\___/_/ \\__,_|\\___/ \\__|_| |_|_|\\___||___/"
  echo "                              |___/"
}

download() {
  if [[ -d "${DOTFILES_DIR}" ]]; then
    log_error "dotfiles already exists: ${DOTFILES_DIR}"
    exit 1
  fi

  log_info "Download dotfiles start."

  if exists_command "curl"; then
    log_info "use curl."
    curl -L "${ARCHIVE_URL}" -o "${ARCHIVE_FILE}"
  elif exists_command "wget"; then
    log_info "use wget."
    wget "${ARCHIVE_URL}"
  else
    log_error "curl or wget required."
    exit 1
  fi

  trap 'rm -f "${ARCHIVE_FILE}"' ERR

  tar -zxvf "${ARCHIVE_FILE}"
  rm -f "${ARCHIVE_FILE}"
  mv -f "dotfiles-${GIT_DEFAULT_BRANCH}" "${DOTFILES_DIR}"

  trap - ERR
  log_success "Download dotfiles"
}

install() {
  show_banner

  download

  cd "${DOTFILES_DIR}" || exit 1
  execute initialize
  execute deploy

  log_success "Install dotfiles complete!"
}

install
