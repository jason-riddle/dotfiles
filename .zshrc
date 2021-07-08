#!/usr/bin/env zsh

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

# Other helpful things
ask_yes_or_no() {
	printf >&2 "$1 ([y]es or [N]o): "
	read REPLY
	case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
		y | yes) echo "yes" ;;
		*) echo "no" ;;
	esac
}

g8reset() {
	if [[ -n $(git status -s) ]]; then
		plog "Workspace is dirty, not resetting and exiting."
		return 2
	fi

	base=$(git merge-base HEAD "${1:-master}")
	echo >&2 "Run: git reset --soft $base?"

	if [[ "no" == $(ask_yes_or_no "Are you sure?") || \
	"no" == $(ask_yes_or_no "Are you *really* sure?") ]]; then
		echo >&2 "Skipped."
		return
	fi

	echo >&2 "Running.."
	git reset --soft "$base"
}
