#!/usr/bin/env zsh

set -o pipefail

# Logging
debug() {
	printf "DEBUG: %s\n" "${@}" >&2
}

fatal() {
	printf "FATAL: %s\n" "${@}" >&2
}

usage() {
	printf "USAGE: %s\n" "${@}" >&2
}

# Set the path
typeset -U PATH path
path=(
	~/code/bin
	~/.local/bin # Python - https://www.python.org/dev/peps/pep-0370/
	/usr/local/opt/git/share/git-core/contrib/diff-highlight # Homebrew - diff-highlight
	/usr/share/doc/git/contrib/diff-highlight # Linux - diff-highlight
	/usr/local/bin
	/usr/local/sbin
	"$path[@]"
)
export PATH

# Set aliases
if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

# Set fpath
if type brew &> /dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit
compinit

# Enable colors
export TERM=screen-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Set prompt
autoload -Uz promptinit && promptinit
prompt bart

# Configure history
HISTSIZE=500000
SAVEHIST=500000
HISTFILE=~/.zsh_history

# Share history across multiple ZSH sessions
setopt SHARE_HISTORY
# Append to history file, don't overwrite
setopt APPEND_HISTORY
# Add commands as they are typed, not just at shell exit
setopt INC_APPEND_HISTORY
# Expire duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_EXPIRE_DUPS_FIRST
# Do not add duplicated commands
setopt HIST_IGNORE_DUPS
# Ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# Remove empty lines from history file
setopt HIST_REDUCE_BLANKS

# Golang
export GOPATH=~/code

# Enable fzf
if [ -f ~/opt/fzf/fzf.zsh ]; then
	. ~/opt/fzf/fzf.zsh
fi

# Configure fzf
if [ -f ~/opt/fzf/fzf-config.zsh ]; then
	. ~/opt/fzf/fzf-config.zsh
fi

# Enable z
if [ -f ~/opt/z/z.sh ]; then
	. ~/opt/z/z.sh
fi

# Enable nix
if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
	. ~/.nix-profile/etc/profile.d/nix.sh
fi

# Other helpful things
if [ -f ~/.zshrc_extras.zsh ]; then
	. ~/.zshrc_extras.zsh
fi
