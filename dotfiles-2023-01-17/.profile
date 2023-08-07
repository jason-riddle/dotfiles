#!/bin/bash

#######################################
# Get the current branch.
# Outputs:
#   Writes current git branch to stdout.
#######################################
parse_git_branch() {
	branch="$(git branch 2>/dev/null | grep '\*' | sed 's|\* ||')"
	# Not on a branch, return nothing.
	if [[ -z "${branch}" ]]; then
		return
	fi

	# Output the current branch.
	echo " [${branch}]"
}

# TODO: Incorporate colors from DEFAULT_PS1 into PS1
# export DEFAULT_PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
export PS1="\u@\h \w\$(parse_git_branch) \$ "

## Source

# Source aliases
if [[ -f "${HOME}/.aliases" ]]; then
	source "${HOME}/.aliases"
fi

# Source z.sh
if [[ -f /etc/profile.d/z.sh ]]; then
	source /etc/profile.d/z.sh
fi

## Path

# Set path for code bin directory
if [[ -d "${HOME}/code/bin" ]]; then
	export PATH="${HOME}/code/bin:${PATH}"
fi

# Set path for go bin directory
if [[ -d "/usr/local/go/bin" ]]; then
	export PATH="/usr/local/go/bin:${PATH}"
fi

# Set path for python bin directory
if [[ -d "${HOME}/.local/bin" ]]; then
	export PATH="${HOME}/.local/bin:${PATH}"
fi

# Set path for macports
if [[ -d "/opt/local/bin" ]]; then
	export PATH="/opt/local/bin:${PATH}"
fi

# Set path for macports python 3.9 install
if [[ -d "/opt/local/Library/Frameworks/Python.framework/Versions/3.9/bin" ]]; then
	export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
fi

# Set path for macports python 3.9 package installs
if [[ -d "$HOME/Library/Python/3.9/bin" ]]; then
	export PATH="$HOME/Library/Python/3.9/bin:${PATH}"
fi

# Set path for macports python 3.10 install
if [[ -d "/opt/local/Library/Frameworks/Python.framework/Versions/3.10/bin" ]]; then
	export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
fi

# Set path for macports python 3.10 package installs
if [[ -d "$HOME/Library/Python/3.10/bin" ]]; then
	export PATH="$HOME/Library/Python/3.10/bin:${PATH}"
fi

# Set path for flyctl
if [[ -d "$HOME/.fly/bin" ]]; then
	export PATH="$HOME/.fly/bin:${PATH}"
fi

# Set path for rust bin directory
if [[ -d "${HOME}/.cargo/bin" ]]; then
	export PATH="${HOME}/.cargo/bin:${PATH}"
fi

## Exports

# Suppress "The default interactive shell is now zsh." message on macOS.
# See: https://support.apple.com/en-us/HT208050
export BASH_SILENCE_DEPRECATION_WARNING='1'

export EDITOR='vim'

## History

# Ref: https://unix.stackexchange.com/a/1292

# Avoid duplicate entries
HISTCONTROL=ignoredups:erasedups
# Store lots of history
export HISTSIZE=100000
export HISTFILESIZE=100000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

## Logging

TERM_CLEAR=$(tput sgr0 2>/dev/null || :)
TERM_RED=$(tput setaf 1 2>/dev/null || :)
log_error() {
	>&2 echo "${TERM_RED}ERROR: $*${TERM_CLEAR}"
}

TERM_GREEN=$(tput setaf 2 2>/dev/null || :)
log_info() {
	>&2 echo "${TERM_GREEN}INFO: $*${TERM_CLEAR}"
}

TERM_BLUE=$(tput setaf 4 2>/dev/null || :)
log_usage() {
	>&2 echo "${TERM_BLUE}USAGE: $*${TERM_CLEAR}"
}

#######################################
# Prompt the user for a yes or no answer.
# Arguments:
#   The answer, read from stdin.
# Outputs:
#   Writes answer to stdout.
#######################################
ask() {
	echo -n "${1} ([y]es or [N]o): " >&2
	read -r ANSWER

	case "$(echo ${ANSWER} | tr '[A-Z]' '[a-z]')" in
		y | yes)
			echo "yes"
			;;
		*)
			echo "no"
			;;
	esac
}

## Docker

# Disable "Use 'docker scan' to run Snyk tests" message
export DOCKER_SCAN_SUGGEST=false

## Fzf

export FZF_DEFAULT_OPTS="
	-i
	--preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || echo {} 2> /dev/null | head -200'
	--layout='reverse'
	--height='30%'
	--border
"

# Source fzf key bindings
if [[ -f /opt/local/share/fzf/shell/key-bindings.bash ]]; then
	source /opt/local/share/fzf/shell/key-bindings.bash
fi

# Source fzf auto completion
if [[ -f /opt/local/share/fzf/shell/completion.bash ]]; then
	source /opt/local/share/fzf/shell/completion.bash
fi

## Git

#######################################
# Soft reset to the main's HEAD commit.
# Returns:
#   0 if reset was successful, non-zero on error.
#######################################
g8reset() {
	status="$(git status --short)"
	if [[ -n "${status}" ]]; then
		log_error "Git workspace is dirty, not resetting."
		return 1
	fi

	base=$(git merge-base HEAD "${1:-main}")
	>&2 echo "Run: git reset --soft ${base}?"

	if [[ "no" == $(ask "Are you sure?") ||
	"no" == $(ask "Are you *really* sure?") ]]; then
		>&2 echo "Skipped."
		return
	fi

	>&2 echo "Running.."
	git reset --soft "${base}"
}

## Git / Github

#######################################
# Get the default branch.
# Outputs:
#   The default branch to stdout.
#######################################
get_default_branch() {
	git config init.defaultBranch 2>/dev/null || echo "main"
}

#######################################
# Get the head branch.
# Outputs:
#   The head branch to stdout.
# Returns:
#   0 if head branch was parsed, non-zero on error.
#######################################
get_head_branch() {
	git symbolic-ref --short HEAD 2>/dev/null
}

#######################################
# Sets the head branch.
# Arguments:
#   The head branch.
# Returns:
#   0 if head branch was set, non-zero on error.
#######################################
set_head_branch() {
	git symbolic-ref HEAD "refs/heads/${1}"
}

#######################################
# Get the root git directory.
# Outputs:
#   The root git directory to stdout.
# Returns:
#   0 if current directory resides in git repository, non-zero on error.
#######################################
git_root_dir() {
	git rev-parse --git-dir 2>/dev/null
}

#######################################
# Initializes a new git repository.
# Returns:
#   0 if git repo is initialized, non-zero on error.
#######################################
git_init() {
	log_info "Git repo initializing."

	current_dir="$(pwd)"
	if [ "$current_dir" = "$HOME/code/src/github.com/jason-riddle" ]; then
		log_error "Refusing to create git repo in $HOME/code/src/github.com/jason-riddle."
		return 1
	fi

	root_dir="$(git_root_dir)"
	if (($? != 0)); then
		log_info "Not in a git repo, running 'git init'."
		git init 2>/dev/null
	fi

	log_info "Configuring .gitignore file."
	cat <<EOF >.gitignore
# Ignore everything
*
# But not these files...
!.gitignore
EOF

	default_branch="$(get_default_branch)"

	log_info "Setting head branch to ${default_branch}."
	set_head_branch "${default_branch}"
	if (($? != 0)); then
		log_error "Failed to set head branch to ${default_branch}."
		return 1
	fi

	log_info "Creating initial commit."
	git add --all && git commit --message "Initial Commit"
	if (($? != 0)); then
		log_error "Failed to create initial commit."
		return 1
	fi

	log_info "Git repo initialized."
}

## Git / Github cont.

#######################################
# Creates a new github repo.
# Returns:
#   0 if a new github repo is created, non-zero on error.
#######################################
create_repo() {
	github_fqdn=${GH_FQDN:-github.com}
	github_repo_owner=${1:-jason-riddle}
	github_repo=$(basename "$PWD")
	github_repo_full_path="https://${github_fqdn}/${github_repo_owner}/${github_repo}"
	gh repo create "${github_repo_full_path}" --private --source=. --remote=origin
}

# WIP
gh_init() {
	git_init
	git_init_exit="$?"

	if [ "$git_init_exit" != "0" ]; then
		fatal "Failed to initialize git repo."
		return "$git_init_exit"
	fi

	log_info "Creating a new github repo."
	create_repo
	create_repo_exit="$?"

	if [ "$create_repo_exit" != "0" ]; then
		fatal "Failed to create github repo."
		return 1
	fi

	log_info "Fetching the head branch."
	head_branch=$(get_head_branch)
	head_branch_exit="$?"

	if [ "$head_branch_exit" != "0" ]; then
		fatal "Failed to fetch the head branch."
		return 1
	fi

	log_info "Creating the init branch."
	git checkout -b init || { echo >&2 "Branch 'init' already exists."; }

	log_info "Pushing and configuring upstream for ${head_branch}."

	git push origin "${head_branch}"
	git_push_origin_head_branch_exit="$?"
	if [ "$git_push_origin_head_branch_exit" != "0" ]; then
		fatal "Failed to push to head branch ${head_branch}."
		return 1
	fi

	git branch --set-upstream-to "origin/${head_branch}" "${head_branch}"
	git_branch_set_upstream_origin_head_exit="$?"
	if [ "$git_branch_set_upstream_origin_head_exit" != "0" ]; then
		fatal "Failed to set upstream origin for head branch ${head_branch}."
		return 1
	fi

	log_info "Pushing and configuring upstream for init."

	git push origin "init"
	git_push_origin_init_branch_exit="$?"
	if [ "$git_push_origin_init_branch_exit" != "0" ]; then
		fatal "Failed to push to init branch."
		return 1
	fi

	git branch --set-upstream-to "origin/init" "init"
	git_branch_set_upstream_origin_init_exit="$?"
	if [ "$git_branch_set_upstream_origin_init_exit" != "0" ]; then
		fatal "Failed to set upstream origin for init branch."
		return 1
	fi

	log_info "Done."
}

## Golang

export GOPATH="${HOME}/code"
export GO111MODULE="auto"

## macOS

marksafe() {
	xattr -d com.apple.quarantine "$1"
}

listening() {
	if [ $# -eq 0 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P
	elif [ $# -eq 1 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
	else
		echo "Usage: listening [pattern]"
	fi
}

## Misc

#######################################
# Search all directories for this directory name.
# Arguments:
#   Directory name, the directory name to search for
# Returns:
#   0 if the search was successful, non-zero on error.
#######################################
dname() {
	[ $# -eq 0 ] && log_usage "${FUNCNAME[0]} 'dir_name'" && return 1
	fd --hidden --follow --exclude .git --type directory "$*"
}

#######################################
# Search all files for this filename.
# Arguments:
#   Filename, the filename to search for
# Returns:
#   0 if the search was successful, non-zero on error.
#######################################
fname() {
	[ $# -eq 0 ] && log_usage "${FUNCNAME[0]} 'file_name'" && return 1
	fd --hidden --follow --exclude .git --type file "$*"
}

#######################################
# Find and replace the matching pattern with the replacement.
# Arguments:
#   Pattern, to replace.
#   Replacement, the string to replace with.
# Returns:
#   0 if the replacement was successful, non-zero on error.
#######################################
sub() {
	[ $# -ne 2 ] && log_usage "${FUNCNAME[0]} 'pattern' 'replacement'" && return 1
	pattern="$1"
	replace="$2"
	command rg -0 --files-with-matches "$pattern" --hidden --glob '!.git' | xargs -0 perl -pi -e "s|$pattern|$replace|g"
}

#######################################
# Search in all files in all subdirectories for this string.
#######################################
s() {
	[ $# -ne 1 ] && log_usage "${FUNCNAME[0]} 'pattern'" && return 1
	string="$1"
	command rg --files-with-matches "$string" --hidden --glob '!.git'
}

## Networking

#######################################
# Print the IP address of the router.
# Returns:
#   0 if the query was successful, non-zero on error.
#######################################
router() {
	if [ "$(uname)" = "Linux" ]; then
		ip route show | grep default | awk '{print $3}'
	elif [ "$(uname)" = "Darwin" ]; then
		netstat -nr -f inet | grep default | grep en | awk '{print $2}'
	fi
}

## Vagrant

export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

## Virtualenvwrapper

# Store project virtualenvs in here
export WORKON_HOME="${HOME}/virtualenvs"

# Exports for macports virtualenvwrapper, using python 3.7
export VIRTUALENVWRAPPER_PYTHON='/opt/local/bin/python3.7'
export VIRTUALENVWRAPPER_VIRTUALENV='/opt/local/bin/virtualenv-3.7'
export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/opt/local/bin/virtualenv-clone-3.7'

# Source virtualenvwrapper functions from macports, using python 3.7
if [[ -f '/opt/local/bin/virtualenvwrapper.sh-3.7' ]]; then
	source '/opt/local/bin/virtualenvwrapper.sh-3.7'
fi

mkv() {
	PROJECT=$(basename $PWD)
	PROJECT_LOWERCASE=$(echo $PROJECT | tr '[:upper:]' '[:lower:]')
	mkvirtualenv "proj-$PROJECT_LOWERCASE"
}

work() {
	PROJECT=$(basename $PWD)
	PROJECT_LOWERCASE=$(echo $PROJECT | tr '[:upper:]' '[:lower:]')
	workon "proj-$PROJECT_LOWERCASE"
}

de() {
	deactivate
}

## z

unalias z 2> /dev/null
z() {
	[ $# -gt 0 ] && _z "$*" && return
	cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf)"
}

## Misc

### Ansible

newansible() {
	log_info "Configuring .ansible-lint file."
	cat <<EOF >.ansible-lint
skip_list:
  - 'yaml'
  - 'no-handler'
  - 'role-name'
EOF

	log_info "Configuring .gitignore file."
	cat <<EOF >.gitignore
*.retry
*/__pycache__
*.pyc
.cache
.venv
EOF

	log_info "Configuring .yamllint file."
	cat <<EOF >.yamllint
---
extends: default

rules:
  line-length:
    max: 180
    level: warning
  truthy:
    ignore: |
      .github

ignore: |
  .github/stale.yml
  .travis.yml
  .venv
EOF

	mkdir -p .github
	log_info "Configuring .github/dependabot.yml file."
	cat <<EOF >.github/dependabot.yml
---
version: 2
updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
EOF
}
