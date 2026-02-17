#!/usr/bin/env bash
set -euo pipefail

readonly DOTFILES_DIR="$HOME/dotfiles"
readonly SCRIPT_DIR="$DOTFILES_DIR/scripts"
readonly GIT_REMOTE_ORIGIN="https://github.com/mt-kage/dotfiles.git"
readonly GIT_DEFAULT_BRANCH="master"

if [[ ! -d "${DOTFILES_DIR}" ]]; then
  echo "[ERROR] dotfiles not found: ${DOTFILES_DIR}" >&2
  exit 1
fi

source "${SCRIPT_DIR}/lib/common.sh"

download() {
  log_info "Download dotfiles start."

  if exists_command "git"; then
    git pull "${GIT_REMOTE_ORIGIN}" "${GIT_DEFAULT_BRANCH}"
  else
    log_error "git required."
    exit 1
  fi

  log_success "Download dotfiles"
}

update() {
  show_banner

  download

  cd "${DOTFILES_DIR}" || exit 1
  execute deploy

  log_success "Update dotfiles complete!"
}

update
