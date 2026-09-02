#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly DOTFILES_DIR
readonly SCRIPT_DIR="${DOTFILES_DIR}/scripts"
readonly HOME_DIR="${DOTFILES_DIR}/home"
readonly CONFIG_DIR="${DOTFILES_DIR}/config"
readonly VIM_DIR="${DOTFILES_DIR}/vim"
readonly KARABINER_DIR="${DOTFILES_DIR}/karabiner"

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

log_info()    {
  echo -e "${BLUE}[INFO]${NC} $*";
}
log_success() {
  echo -e "${GREEN}[OK]${NC} $*";
}
log_warn()    {
  echo -e "${YELLOW}[WARN]${NC} $*" >&2;
}
log_error()   {
  echo -e "${RED}[ERROR]${NC} $*" >&2;
}

exists_command() {
  type -a "$1" >/dev/null 2>&1
}

execute() {
  log_info "[${SCRIPT_DIR}/lib/${1}.sh] START"
  /bin/bash "${SCRIPT_DIR}/lib/${1}.sh"
}

is_arm() {
  [[ "$(uname -m)" == "arm64" || "$(uname -m)" == "aarch64" ]]
}

is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

is_linux() {
  [[ "$(uname)" == "Linux" ]]
}

is_wsl() {
  if is_linux && { [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ -n "${WSL_INTEROP:-}" ]] || uname -r | grep -qi 'microsoft' || ( [[ -f /proc/version ]] && grep -qi 'microsoft' /proc/version ); }; then
    return 0
  else
    return 1
  fi
}

is_ubuntu() {
  if is_linux && [[ -f /etc/os-release ]] && grep -qiE 'ID(=|=")(ubuntu|debian)' /etc/os-release; then
    return 0
  else
    return 1
  fi
}

show_banner() {
  cat <<'EOF'
           _        _                       __  _       _    __ _ _
 _ __ ___ | |_     | | ____ _  __ _  ___   / /_| | ___ | |_ / _(_) | ___  ___
| '_ ` _ \| __|____| |/ / _` |/ _` |/ _ \ / / _` |/ _ \| __| |_| | |/ _ \/ __|
| | | | | | ||_____|   < (_| | (_| |  __// / (_| | (_) | |_|  _| | |  __/\__ \
|_| |_| |_|\__|    |_|\_\__,_|\__, |\___/_/ \__,_|\___/ \__|_| |_|_|\___||___/
                              |___/
EOF
}
