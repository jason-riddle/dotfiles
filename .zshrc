#!/usr/bin/env zsh

if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

typeset -U PATH path
path=($GOPATH/bin ~/.local/bin /usr/local/bin /usr/local/sbin "$path[@]")
export PATH

autoload -Uz compinit promptinit
compinit
promptinit

# Set prompt
prompt bart

# Enable colors
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
