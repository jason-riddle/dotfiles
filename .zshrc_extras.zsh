#!/usr/bin/env zsh

set -o pipefail

## General

ask_yes_or_no() {
	printf >&2 "$1 ([y]es or [N]o): "
	read REPLY
	case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
		y | yes) echo "yes" ;;
		*) echo "no" ;;
	esac
}

# https://www.netmeister.org/blog/keychain-passwords.html
#
# File -> New Password Item..
# Keychain Item Name: example
# Account Name: jason
# Password: password
#
# Retrieve with: security find-generic-password -a "$USER" -s "example" -w
get_password() {
	app="$1"
	security find-generic-password -a "$USER" -s "$app" -w
}

marksafe() {
	xattr -d com.apple.quarantine "$1"
}

## Git

g8reset() {
	if [[ -n $(git status -s) ]]; then
		debug "Workspace is dirty, not resetting and exiting."
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

git_init() {
	git_repo_exists=$(git rev-parse --git-dir 2> /dev/null)
	git_repo_exists_exit="$?"

	if [ "$git_repo_exists_exit" != "0" ]; then
		debug "No git repo exists, preparing new repo."
		git init
	fi

	debug "Creating .gitignore file."
	cat << EOF > .gitignore
# Ignore everything
*
# But not these files...
!.gitignore
!.gitkeep
!.keep
EOF

	debug "Creating .keep file."
	touch .keep

	email=$(get_password "git-email")
	debug "Setting git commit email to $email."
	git config user.email "$email"

	debug "Creating initial commit."
	initial_commit=$(git add -A && git commit -m "Initial Commit")
	initial_commit_exit="$?"

	debug "Git repo ready."
}

gh_init() {
	git_init

	debug "Missing implementation.."

	# if [ "$initial_commit_exit" != "0" ]; then
	# 	fatal "Failed to create initial commit, exiting."
	# 	return 2
	# fi

	# github_repo=$(basename "$PWD")
	# github_repo_exists=$(gh repo list --limit 100 | grep $github_repo)
	# github_repo_exists_exit="$?"

	# debug "1"

	# if [ "$git_repo_exists_exit" != "0" ]; then
	# 	debug "No github repo exists, preparing new repo."
	# 	debug "doing stuff."
	# 	debug "10"
	# fi

	# debug "100"

	debug "Done."
}

## Searching

# Find all files that contain this name
fname() {
	[ $# -eq 0 ] && puse "$0 'file_name'" && return 1
	fd --hidden --follow --exclude .git --type file "$*"
}

# Search for all directories that contains this name
dname() {
	[ $# -eq 0 ] && puse "$0 'dir_name'" && return 1
	fd --hidden --follow --exclude .git --type directory "$*"
}

## Replacing

# Find 'pattern' and replace with 'replacement'
sub() {
	[ $# -ne 2 ] && puse "$0 'pattern' 'replacement'" && return 1
	pattern="$1"
	replace="$2"
	command rg -0 --files-with-matches "$pattern" | xargs -0 perl -pi -e "s|$pattern|$replace|g"
}
