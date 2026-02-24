if [[ `uname -m` == "arm64" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# aliases and prompts are loaded in .zshrc
for file in ~/.{path,exports}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

export ZPROFILE_LOADED="true"
