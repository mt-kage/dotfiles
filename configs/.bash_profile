# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

if [[ `uname -m` == "arm64" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
fi;

if which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh" ]; then
	source "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh";
fi;

if which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
	source "$(brew --prefix)/etc/bash_completion.d/git-completion.bash";
fi;

if which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion.d/gibo-completion.bash" ]; then
	source "$(brew --prefix)/etc/bash_completion.d/gibo-completion.bash";
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# anyenv.
if which anyenv &> /dev/null; then
	eval "$(anyenv init - --no-rehash)";
fi;

# direnv
if which direnv &> /dev/null; then
	eval "$(direnv hook bash)";
fi;

# fig
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh

