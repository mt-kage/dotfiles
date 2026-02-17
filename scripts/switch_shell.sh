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
  local current target target_path
  current="$(current_shell)"
  target="$(target_shell)"
  target_path="$(target_shell_path)"

  if [[ ! -x "$target_path" ]]; then
    log_error "$target_path が見つかりません。"
    exit 1
  fi

  log_info "現在のシェル: $current"
  log_info "切り替え先:   $target ($target_path)"

  read -rp "デフォルトシェルを $target に切り替えますか？ [y/N] " answer
  if [[ "${answer,,}" != "y" ]]; then
    log_warn "キャンセルしました。"
    exit 0
  fi

  chsh -s "$target_path"
  log_success "デフォルトシェルを $target に切り替えました。"
  log_info "変更を反映するにはターミナルを再起動してください。"
}

switch_shell
