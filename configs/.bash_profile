if [[ `uname -m` == "arm64" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# aliases, prompt and completions are loaded in .bashrc
for file in ~/.{path,exports}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

export BASH_PROFILE_LOADED="true"
