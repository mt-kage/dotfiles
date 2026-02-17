#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"

readonly DRY_RUN="${1:-}"

deploy_configs() {
  log_info "deploy configs start..."
  cd "${CONFIGS_DIR}" || exit 1
  for file in .??*; do
    [[ "$file" = ".git" ]] && continue
    [[ "$file" = ".DS_Store" ]] && continue
    if [[ "${DRY_RUN}" == "--dry-run" ]]; then
      echo "  (dry-run) ln -fvns \"${CONFIGS_DIR}/${file}\" \"${HOME}/${file}\""
    else
      ln -fvns "${CONFIGS_DIR}/${file}" "${HOME}/${file}"
    fi
  done
  log_success "deploy configs"
}

deploy_vim() {
  log_info "deploy vim start..."
  if [[ "${DRY_RUN}" == "--dry-run" ]]; then
    echo "  (dry-run) ln -fvns \"${VIM_DIR}\" \"${HOME}/.vim\""
  else
    ln -fvns "${VIM_DIR}" "${HOME}/.vim"
  fi
  log_success "deploy vim"
}

deploy_karabiner() {
  log_info "deploy karabiner start..."
  if [[ "${DRY_RUN}" == "--dry-run" ]]; then
    echo "  (dry-run) ln -fvns \"${KARABINER_DIR}/karabiner.json\" \"${HOME}/.config/karabiner/karabiner.json\""
  else
    ln -fvns "${KARABINER_DIR}/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
  fi
  log_success "deploy karabiner"
}

deploy() {
  log_info "deploy start."
  [[ "${DRY_RUN}" == "--dry-run" ]] && log_warn "DRY-RUN モード: 実際の変更は行いません"

  deploy_configs
  deploy_vim
  deploy_karabiner

  if [[ "${DRY_RUN}" != "--dry-run" ]]; then
    if [[ -n "${ZSH_VERSION:-}" ]]; then
      source ~/.zshrc
    else
      source ~/.bashrc
    fi
  fi

  log_success "deploy complete!"
}

deploy
