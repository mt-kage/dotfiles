# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH";
export PATH="$HOME/.opencode/bin:$PATH";

if [[ `uname -m` == "arm64" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,zsh_prompt,exports,aliases}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
setopt NO_CASE_GLOB;

# Append to the zsh history file, rather than overwriting it
setopt APPEND_HISTORY;

# Share history between sessions
setopt SHARE_HISTORY;

# Autocorrect typos in path names when using `cd`
setopt CDSPELL 2>/dev/null;

# Enable extended globbing, e.g. `echo **/*.txt`
setopt EXTENDED_GLOB;

# Allow `cd` without typing `cd`
setopt AUTO_CD;

# Initialize completion system
autoload -Uz compinit && compinit;

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}';

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
	h=()
	if [[ -r ~/.ssh/config ]]; then
		h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
	fi
	if (( ${#h} > 0 )); then
		zstyle ':completion:*:ssh:*' hosts $h
		zstyle ':completion:*:scp:*' hosts $h
		zstyle ':completion:*:sftp:*' hosts $h
	fi
fi

# Google Cloud SDK completion
if which brew &>/dev/null && [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]; then
	source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc";
fi;

if which brew &>/dev/null && [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then
	source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc";
fi;

# anyenv.
if which anyenv &>/dev/null; then
	eval "$(anyenv init - --no-rehash)";
fi;

# direnv
if which direnv &>/dev/null; then
	eval "$(direnv hook zsh)";
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

# sdkman
if brew list sdkman-cli &> /dev/null; then
	export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
	[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi
