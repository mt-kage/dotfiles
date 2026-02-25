# Load zprofile if not already loaded (for non-login shells)
if [ -z "$ZPROFILE_LOADED" ]; then
    [ -n "$PS1" ] && [ -f ~/.zprofile ] && source ~/.zprofile;
fi

# Load the shell dotfiles, and then some:
for file in ~/.{zsh_prompt,aliases}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
setopt NO_CASE_GLOB;

# Append to the zsh history file, rather than overwriting it
setopt APPEND_HISTORY;

# Share history between sessions
setopt SHARE_HISTORY;

# Enable Emacs keybind
bindkey -e

# Use the text that has already been typed as the prefix for searching through
# commands (i.e. more intelligent Up/Down behavior)
if [[ "${TERM}" != "dumb" ]]; then
	bindkey '^[[A' history-beginning-search-backward
	bindkey '^[[B' history-beginning-search-forward
	bindkey '^[OA' history-beginning-search-backward
	bindkey '^[OB' history-beginning-search-forward

	# Option + Delete / Option + Backspace for word deletion
	bindkey '^[[3;3~' kill-word
	bindkey '^[^?' backward-kill-word
fi

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

# Tab menu selection (Enhancement over bash's show-all-if-ambiguous)
zstyle ':completion:*' menu select

# If there are more than 200 possible completions for a word, ask to show them all (Same as completion-query-items 200)
export LISTMAX=200

# Immediately add a trailing slash to directory paths (Same as mark-symlinked-directories on)
setopt MARK_DIRS

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
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
