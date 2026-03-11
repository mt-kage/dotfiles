#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

readonly DRY_RUN="${1:-}"

cleanup_old_configs() {
  log_info "cleanup old configs start..."

  local -a search_dirs=("${HOME}" "${HOME}/.config")
  local removed=0

  for search_dir in "${search_dirs[@]}"; do
    [[ ! -d "${search_dir}" ]] && continue

    while IFS= read -r -d '' link; do
      local target
      target="$(readlink "${link}")"
      # Only remove symlinks pointing to the dotfiles repository
      if [[ "${target}" == "${DOTFILES_DIR}/"* ]]; then
        if [[ "${DRY_RUN}" == "--dry-run" ]]; then
          echo "  (dry-run) rm -f \"${link}\""
        else
          rm -f "${link}"
          log_info "removed symlink: ${link} -> ${target}"
          (( removed++ )) || true
        fi
      fi
    done < <(find "${search_dir}" -maxdepth 1 -type l -print0)
  done

  log_success "cleanup old configs (${removed} removed)"
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

deploy_mise() {
  log_info "deploy mise start..."
  mise -C ~ install
  log_success "deploy mise"
}

deploy() {
  log_info "deploy start."
  [[ "${DRY_RUN}" == "--dry-run" ]] && log_warn "DRY-RUN mode: no changes will be made"

  cleanup_old_configs
  deploy_home
  deploy_config
  deploy_karabiner
  deploy_mise

  if [[ "${DRY_RUN}" != "--dry-run" ]]; then
    # Reload shell config in a login shell subprocess.
    # Cannot source zsh configs from bash (or vice versa), so spawn the
    # user's login shell instead.
    log_info "reloading shell config..."
    "$SHELL" -l -c 'echo "shell config loaded successfully"'
  fi

  log_success "deploy complete!"
}

deploy
