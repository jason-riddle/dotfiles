#!/usr/bin/env zsh

if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

typeset -U PATH path
path=(/usr/local/bin /usr/local/sbin "$path[@]")
export PATH

if [ -f ~/.zsh/extras.zsh ]; then
	. ~/.zsh/extras.zsh
fi
