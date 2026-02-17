#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

readonly BASH_PATH="/bin/bash"
readonly ZSH_PATH="/bin/zsh"

current_shell() {
  basename "$SHELL"
}

target_shell() {
  local current
  current="$(current_shell)"

  if [[ "$current" == "bash" ]]; then
    echo "zsh"
  else
    echo "bash"
  fi
}

target_shell_path() {
  local target
  target="$(target_shell)"

  if [[ "$target" == "bash" ]]; then
    echo "$BASH_PATH"
  else
    echo "$ZSH_PATH"
  fi
}

switch_shell() {
  show_banner

  local current target target_path
  current="$(current_shell)"
  target="$(target_shell)"
  target_path="$(target_shell_path)"

  if [[ ! -x "$target_path" ]]; then
    log_error "$target_path not found."
    exit 1
  fi

  log_info "Current shell: $current"
  log_info "Switch to:     $target ($target_path)"

  read -rp "Switch default shell to $target? [y/N] " answer
  if [[ "${answer,,}" != "y" ]]; then
    log_warn "Cancelled."
    exit 0
  fi

  chsh -s "$target_path"
  log_success "Default shell has been switched to $target."
  log_info "Please restart your terminal to apply the changes."
}

switch_shell
