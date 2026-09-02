#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

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

  local shell_bin
  shell_bin="$(command -v "$target" 2>/dev/null || true)"
  if [[ -n "$shell_bin" && -x "$shell_bin" ]]; then
    echo "$shell_bin"
  elif [[ "$target" == "bash" ]]; then
    echo "/bin/bash"
  else
    echo "/bin/zsh"
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
