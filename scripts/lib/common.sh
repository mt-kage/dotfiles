#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly DOTFILES_DIR
readonly SCRIPT_DIR="${DOTFILES_DIR}/scripts"
readonly CONFIGS_DIR="${DOTFILES_DIR}/configs"
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
  log_info "[${SCRIPT_DIR}/${1}.sh] START"
  /bin/bash "${SCRIPT_DIR}/${1}.sh"
}

is_arm() {
  [[ "$(uname -m)" == "arm64" ]]
}

is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

show_banner() {
  echo "           _        _                       __  _       _    __ _ _"
  echo " _ __ ___ | |_     | | ____ _  __ _  ___   / /_| | ___ | |_ / _(_) | ___  ___"
  echo "| '_ \` _ \\| __|____| |/ / _\` |/ _\` |/ _ \\ / / _\` |/ _ \\| __| |_| | |/ _ \\/ __|"
  echo "| | | | | | ||_____|   < (_| | (_| |  __// / (_| | (_) | |_|  _| | |  __/\\__ \\"
  echo "|_| |_| |_|\\__|    |_|\\_\\__,_|\\__, |\\___/_/ \\__,_|\\___/ \\__|_| |_|_|\\___||___/"
  echo "                              |___/"
}
