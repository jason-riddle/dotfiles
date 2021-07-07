#!/usr/bin/env zsh

if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

autoload -Uz compinit promptinit
compinit
promptinit

# Set prompt
prompt suse
