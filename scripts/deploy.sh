#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"

readonly DRY_RUN="${1:-}"

cleanup_old_configs() {
  log_info "cleanup old configs start..."
  
  local old_files=(
    .aliases .bash_profile .bash_prompt .bashrc .curlrc .digrc .editorconfig
    .exports .gitconfig .gitignore .gvimrc .hgignore .hushlogin .inputrc
    .screenrc .vimrc .wgetrc .zprofile .zsh_prompt .zshrc
  )

  for file in "${old_files[@]}"; do
    local target="${HOME}/${file}"
    if [[ -L "${target}" ]]; then
      if [[ "${DRY_RUN}" == "--dry-run" ]]; then
        echo "  (dry-run) rm -f \"${target}\""
      else
        rm -f "${target}"
        log_info "removed old symlink: ${target}"
      fi
    fi
  done
  log_success "cleanup old configs"
}

deploy_home() {
  log_info "deploy home configs start..."
  cd "${HOME_DIR}" || exit 1
  for file in .??*; do
    [[ "$file" = ".git" ]] && continue
    [[ "$file" = ".DS_Store" ]] && continue
    if [[ "${DRY_RUN}" == "--dry-run" ]]; then
      echo "  (dry-run) ln -fvns \"${HOME_DIR}/${file}\" \"${HOME}/${file}\""
    else
      ln -fvns "${HOME_DIR}/${file}" "${HOME}/${file}"
    fi
  done
  log_success "deploy home configs"
}

deploy_config() {
  log_info "deploy XDG configs start..."
  
  local xdg_config_dir="${HOME}/.config"
  if [[ "${DRY_RUN}" != "--dry-run" ]]; then
    mkdir -p "${xdg_config_dir}"
  else
    echo "  (dry-run) mkdir -p \"${xdg_config_dir}\""
  fi

  cd "${CONFIG_DIR}" || exit 1
  for dir in *; do
    [[ ! -d "${dir}" ]] && continue
    if [[ "${DRY_RUN}" == "--dry-run" ]]; then
      echo "  (dry-run) ln -fvns \"${CONFIG_DIR}/${dir}\" \"${xdg_config_dir}/${dir}\""
    else
      ln -fvns "${CONFIG_DIR}/${dir}" "${xdg_config_dir}/${dir}"
    fi
  done
  log_success "deploy XDG configs"
}

deploy_vim() {
  log_info "skip legacy deploy_vim (moved to config/vim)"
}

deploy_karabiner() {
  if ! is_macos; then
    log_info "skip deploy karabiner (not macOS)"
    return
  fi

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

  cleanup_old_configs
  deploy_home
  deploy_config
  deploy_karabiner

  if [[ "${DRY_RUN}" != "--dry-run" ]]; then
    if [[ -n "${ZSH_VERSION:-}" ]]; then
      source ~/.zshenv
      source ~/.config/zsh/.zshrc
    else
      source ~/.bash_profile
    fi
  fi

  log_success "deploy complete!"
}

deploy
