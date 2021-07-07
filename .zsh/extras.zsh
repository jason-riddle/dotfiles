#!/usr/bin/env zsh

typeset -U PATH path
path=(~/code/bin ~/.local/bin "$path[@]")
export PATH

# Set prompt
autoload -Uz promptinit && promptinit
prompt bart

# Enable colors
export TERM=screen-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

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

# Extra aliases
alias cat="bat"
alias dl="youtube-dl"
alias get="aria2c"
alias k="kubectl"
alias ls="exa --group-directories-first"
alias vim="nvim"

# Enable z
if [ -f ~/.extras/z.sh ]; then
	. ~/.extras/z.sh
fi

# Enable fzf
if [ -f ~/.extras/.fzf.zsh ]; then
	. ~/.extras/.fzf.zsh
fi
