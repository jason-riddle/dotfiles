#!/bin/bash

set -e
set -u

debug() {
	printf "DEBUG: %s\n" "${@}" >&2
}

usage() {
	printf "USAGE: %s\n" "${@}" >&2
}

# https://www.mkssoftware.com/docs/man1/test.1.asp

link() {
	[ $# -ne 2 ] && usage "$0 'must_exist' 'will_be_created'" && return 1

	must_exist="$1"
	will_be_created="$2"

	if ! [ -e "$must_exist" ]; then
		debug "$must_exist does not exist, exiting."
		return 1
	fi

	if [ -L "$will_be_created" ]; then
		target=$(readlink $will_be_created)

		if [ "$target" == "$must_exist" ]; then
			debug "$will_be_created is already a link and points to $must_exist, skipping."
			return
		fi

		debug "$will_be_created does not match the expected target, removing."
		rm "$will_be_created"
	fi

	debug "running: ln -s \"$must_exist\" \"$will_be_created\""
	ln -s "$must_exist" "$will_be_created"
}

# https://stackoverflow.com/a/53183593/7086324
DOTFILES_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

mkdir -p ~/.ssh

link $DOTFILES_DIR/.ssh/config ~/.ssh/config
link $DOTFILES_DIR/opt ~/opt

link $DOTFILES_DIR/.aliases ~/.aliases
link $DOTFILES_DIR/.gitattributes-global ~/.gitattributes-global
link $DOTFILES_DIR/.gitconfig ~/.gitconfig
link $DOTFILES_DIR/.gitconfig-diff-highlight ~/.gitconfig-diff-highlight
link $DOTFILES_DIR/.gitignore-global ~/.gitignore-global
link $DOTFILES_DIR/.vimrc ~/.vimrc
link $DOTFILES_DIR/.zshrc ~/.zshrc
link $DOTFILES_DIR/.zshrc_extras.zsh ~/.zshrc_extras.zsh

debug "done."
