# Source shared XDG configuration
# Note: path must be hardcoded here as XDG vars are not yet defined at this point
source "${HOME}/.config/shared/.xdg"

if [[ `uname -m` == "arm64" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# aliases and prompts are loaded in .bashrc
for file in "${XDG_SHARED_CONFIG_HOME}"/.{path,exports}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

export BASH_PROFILE_LOADED=true
source "${XDG_CONFIG_HOME}/bash/.bashrc"
