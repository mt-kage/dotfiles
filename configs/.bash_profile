# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bash_profile.pre.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.pre.bash"

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

if which brew &> /dev/null && [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]; then
	source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc";
fi;

if which brew &> /dev/null && [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc" ]; then
	source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc";
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

# python auto activate
python_auto_activate() {
	if [ -e ".venv" ]; then
		if [ "${VIRTUAL_ENV}" != "$(pwd)/.venv" ]; then
			source "$(pwd)/.venv/bin/activate"
		fi
	else
		if [ "${VIRTUAL_ENV}" != "" ]; then
		deactivate
		fi
	fi
}
precmd_functions+=(python_auto_activate)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bash_profile.post.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.post.bash"
