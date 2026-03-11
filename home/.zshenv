# Source shared XDG configuration
# Note: path must be hardcoded here as XDG vars are not yet defined at this point
source "${HOME}/.config/shared/.xdg"

# Zsh dotfile dir
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
