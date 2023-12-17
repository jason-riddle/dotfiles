#!/usr/bin/env bash

# SC1091: Not following: (error message here)
# SC2181: Check exit code directly with e.g. if mycmd;, not indirectly with $?.
# SC2196: egrep is non-standard and deprecated. Use grep -E instead.
# shellcheck disable=SC1091,SC2181,SC2196

## BASH

## BASH - ALIAS

# Alias r for sourcing .profile.
alias r="source \${HOME}/.profile"

## BASH - EDITOR

# Use vim for editor.
export EDITOR='vim'

## BASH - HISTORY
## REF: https://web.archive.org/web/https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows/1292#1292

# Store a lot of history.
export HISTSIZE='100000'
export HISTFILESIZE='100000'

# Ignore storing duplicate commands.
export HISTCONTROL='ignorespace:ignoredups'

# When the shell exits, append to the history file instead of overwriting it.
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

## BASH - HELPERS

# Prompts with a question and expects a "yes" or "no" response.
#
# Outputs:
#   Outputs the "yes" or "no" answer.
# Returns:
#   0 on success, non-zero on error.
ask() {
	# Read the answer.
	>&2 echo -n "${1} ([y]es or [N]o): "
	read -r ANSWER

	# Transform the answer to lowercase for case-insensitive comparison.
	ANSWER_LOWER=$(echo "${ANSWER}" | tr '[:upper:]' '[:lower:]')

	# If it equals y or yes, then output yes. Otherwise output no.
	case "${ANSWER_LOWER}" in
		y | yes)
			echo "yes"
			;;
		*)
			echo "no"
			;;
	esac
}

## BASH - PATH

PATH_BINS=(
	# NixOS
	"${HOME}/.nix-profile/bin"
	"/nix/var/nix/profiles/default/bin"

	# Home
	"${HOME}/bin"

	# Homebrew
	"/opt/homebrew/bin"

	# MacPorts
	"/opt/local/bin"

	# System
	"/usr/local/sbin"
	"/usr/local/bin"
	"/usr/sbin"
	"/usr/bin"
	"/sbin"
	"/bin"
)

# Joins the elements of PATH_BINS into a string.
#
# Outputs:
#   Outputs PATH_BINS as string.
# Returns:
#   0 on success, non-zero on error.
build_path() {
	# Concat PATH_BINS into a string, delimited by ':'. Use subshell to avoid
	# modifying IFS.
	#
	# REF: https://web.archive.org/web/https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash/53050617#53050617
	(IFS=':'; printf '%s' "${PATH_BINS[*]}")
	echo
}

# Set the PATH environment variable.
PATH="$(build_path)"
export PATH

## BASH - PROMPT

# Outputs the current git branch formatted for use in PS1.
#
# Outputs:
#   Outputs the current git branch, outputs nothing if not on a git branch.
# Returns:
#   0 on success, non-zero on error.
ps1_git_branch() {
	# Get the current git branch, strip away extra formatting.
	local git_branch
	git_branch="$(git branch 2>/dev/null | grep '\*' | sed 's|\* ||')"

	# If git_branch is empty, then we are not on a branch, so don't output anything and exit.
	if [[ -z "${git_branch}" ]]; then
		return
	fi

	# Otherwise, we are on a branch. Output the branch name formatted for PS1 use.
	echo " (${git_branch})"
}

# Set the prompt.
# $USER@$HOSTNAME $PWD
export PS1="(\t) [\u@\h:\w]\$(ps1_git_branch) \$ "

## ---

## CODE USER - EXPORTS
export CODE_USER=''

if [[ "${USER}" == 'jason' ]]; then
	export CODE_USER='jason-riddle'
fi

if [[ "${USER}" == 'jriddle.admin' ]]; then
	export CODE_USER='jasonarccsf'
fi

## CODE WORKSPACE - EXPORTS

# Various CODE_WORKSPACE env vars to use in functions below.
export CODE_WORKSPACE="${HOME}/code"
export CODE_WORKSPACE_BIN="${CODE_WORKSPACE}/bin"
export CODE_WORKSPACE_SRC="${CODE_WORKSPACE}/src"

## GITHUB REPO - EXPORTS

# Various GITHUB env vars to use in functions below.
export GITHUB_FQDN='github.com'
export GITHUB_USER="${CODE_USER}"

## SECRETS - EXPORTS

## ---

## 1PASSWORD CLI (OP)

## 1PASSWORD CLI (OP) - EXPORTS

## 1PASSWORD CLI (OP) - FUNCTIONS

## AGE (https://github.com/FiloSottile/age)

## ANSIBLE

## ANSIBLE - ALIAS

# Some helpful aliases.
alias a='ansible'
alias ap='ansible-playbook'

## ANSIBLE-GALAXY

## ANSIBLE-VAULT

## ANSIBLE-VAULT - EXPORTS

## APT

## ARIA2C

## AWSCLI

## AWSSAMCLI

## AWSSAMCLI - ANALYTICS/TELEMETRY

# Disable telemetry.
export SAM_CLI_TELEMETRY=0

## BAT (https://github.com/sharkdp/bat)

## CLOUDFLARE

## CONDA

## CONDA - INIT

# Homebrew init
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
		. "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
	else
		export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

## CONSUL

## DEBIAN

## DEVENV (https://github.com/cachix/devenv)

## DIGITAL OCEAN

## DIRENV (https://github.com/direnv/direnv)

## DOCKER

## DOCKER - EXPORTS

# Disable the "Use 'docker scan' to run Snyk tests" message.
export DOCKER_SCAN_SUGGEST='false'

## DOPPLER

## DOTBOT

## ENCRYPT / DECRYPT

## FD (https://github.com/sharkdp/fd)

## FFMPEG

## FLY.IO / FLYCTL

## FZF (https://github.com/junegunn/fzf)

## FZF - EXPORTS

# -i                 - Case-insensitive match
# --preview          - Show a preview of a file.
# --layout='reverse' - Show the layout on the bottom instead of the top
# --height='30%'     - Set the height to be 30% of the window
# --border           - Draw a border around the fzf prompt
export FZF_DEFAULT_OPTS="
	-i
	--preview='([[ -f {} ]] && (bat --style=numbers --color=always {} 2>/dev/null || cat {})) || echo {} 2>/dev/null | head -200'
	--layout='reverse'
	--height='90%'
	--border
"

## FZF - SOURCE

# Source fzf keybindings (Homebrew).
if [[ -f "${HOME}/.fzf.bash" ]]; then
	source "${HOME}/.fzf.bash"
fi

# Source fzf keybindings (MacPorts).
if [[ -f "/opt/local/share/fzf/shell/key-bindings.bash" ]]; then
	source "/opt/local/share/fzf/shell/key-bindings.bash"
fi

## GCLOUD / GCP

# Add gcloud components to the path (Homebrew)
if [[ -f "/opt/homebrew/share/google-cloud-sdk/path.bash.inc" ]]; then
	source "/opt/homebrew/share/google-cloud-sdk/path.bash.inc"
fi

# Add gcloud components to the path (Manual)
if [[ -f "/opt/google/google-cloud-sdk/path.bash.inc" ]]; then
	source "/opt/google/google-cloud-sdk/path.bash.inc"
fi

## GHQ (https://github.com/x-motemen/ghq)

## GHQ - EXPORTS

## GIT

## GIT - ALIAS

# Some helpful aliases.

# All of the ways I've misspppellllled git.
alias g='git'
alias gi='git'
alias gt='git'
alias gti='git'

# Workflows
alias gbd='git branch -D'
alias gac='git add -A && git commit -m "Update"'
alias gacup='git add -A && git commit -m "Update" && git push'
alias gco='git checkout'
alias gcob='git checkout -b'

## GIT - FUNCTIONS

## git_init

# Creates a new git repo.
#
# Outputs:
#   Creates a new local git repo, exits if one already exists.
# Returns:
#   0 on success, non-zero on error.
git_init() {
	# Check to see if git is available on the path, fail if it's missing.
	if ! command -v git &> /dev/null; then
		>&2 echo "refusing to run, git command not found in path"
		return 1
	fi

	# TODO: Do I need the version info for only running specific commands?
	# GIT_VERSION="$(git --version | rev | cut -d' ' -f1 | rev)"
	# GIT_MAJOR_VERSION="$(echo $GIT_VERSION | cut -d'.' -f1)"
	# GIT_MINOR_VERSION="$(echo $GIT_VERSION | cut -d'.' -f2)"
	# GIT_PATCH_VERSION="$(echo $GIT_VERSION | cut -d'.' -f3)"

	# Check to see if we are in the top level code directory, fail if we are.
	# if [[ "${PWD}" == "${CODE_WORKSPACE_SRC_GITHUB_COM_JASON_RIDDLE}" ]]; then
	# 	>&2 echo "failed to create git repo, refusing to create repo in top level code directory"
	# 	return 1
	# fi

	# Check to see if a repo already exists, fail if it does.
	>&2 echo "checking if git repo in '${PWD}' already exists."
	if git rev-parse --git-dir 2>/dev/null; then
		>&2 echo "refusing to create repo, git repo in '${PWD}' already exists"
		return 1
	fi

	# We are not in a git repo, so create one.
	>&2 echo "running 'git init' in '${PWD}'"
	git init 2>/dev/null
	if (( $? != 0 )); then
		>&2 echo "failed to run git init."
		return 1
	fi

	# Set the default branch. Read $(git config init.defaultBranch) or use main
	# as default
	local git_default_branch
	git_default_branch="$(git config init.defaultBranch 2>/dev/null || echo 'main')"

	# Set the head branch for the local git repo.
	>&2 echo "setting head branch to ${git_default_branch}."
	git symbolic-ref HEAD "refs/heads/${git_default_branch}"
	if (( $? != 0 )); then
		>&2 echo "setting head branch failed."
		return 1
	fi

	# Create a .gitignore file.
	>&2 echo "creating .gitignore file."
	cat <<EOF >.gitignore
# Ignore everything
*
# But not these files...
!.gitignore

## Uncomment below as necessary.

## DEVENV

# .devenv
# .devenv.flake.nix

## TERRAFORM

# .terraform
# .terraform.lock.hcl
EOF

	# TODO: Should this be created here or in github_init?
	# Dependabot is a GitHub bot that scans you dependencies and creates pull
	# requests to bump those dependencies as new versions are released.
	>&2 echo "creating .github/dependabot.yml file."
	mkdir -p .github
	cat <<EOF >.github/dependabot.yml
---
# REF: https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file
version: 2
updates:
  - package-ecosystem: bundler
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: cargo
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: composer
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: docker
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: gitsubmodule
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: gomod
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: gradle
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: maven
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: nuget
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: pip
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: pipenv
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: pip-compile
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: pnpm
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: poetry
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: terraform
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: yarn
    directory: /
    schedule:
      interval: monthly
EOF

	# TODO: Should this be created here or in github_init?
	# Super-linter is a GitHub mega linter for linting multiple languages.
	>&2 echo "creating .github/env/super-linter.env file."
	mkdir -p .github/env
	cat <<EOF >.github/env/super-linter.env
DEFAULT_BRANCH=main
LOG_LEVEL=VERBOSE
SUPPRESS_POSSUM=true
VALIDATE_ALL_CODEBASE=true
VALIDATE_DOCKERFILE_HADOLINT=false
VALIDATE_GITHUB_ACTIONS=false
VALIDATE_JSCPD=false
VALIDATE_JSON=false
VALIDATE_KUBERNETES_KUBECONFORM=false
VALIDATE_MARKDOWN=false
VALIDATE_NATURAL_LANGUAGE=false
VALIDATE_TERRAFORM_TERRASCAN=false
VALIDATE_TERRAFORM_TFLINT=false
VALIDATE_YAML=false
EOF

	# TODO: Should this be created here or in github_init?
	# Super-linter is a GitHub mega linter for linting multiple languages.
	>&2 echo "creating .github/workflows/ci-super-linter.yml file."
	mkdir -p .github/workflows
	cat <<EOF >.github/workflows/ci-super-linter.yml
---
name: CI - Super-Linter

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - '*'

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - name: Check out the codebase.
        uses: actions/checkout@v4

      - name: Read env vars from super-linter.env.
        run: |
          cat .github/env/super-linter.env >> "\$GITHUB_ENV"

      - name: Lint code.
        uses: super-linter/super-linter/slim@v5
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
EOF

	# Create the initial commit.
	>&2 echo "creating initial commit."
	git add --all && git commit --message "Initial Commit"
	if (( $? != 0 )); then
		>&2 echo "failed to create initial commit."
		return 1
	fi

	>&2 echo "git repo created."
}

# Deletes all local branches except master, main, and init.
#
# Outputs:
#   Nothing.
# Returns:
#   0 on success, non-zero on error.
gbr() {
	# Get all of the git branches.
	local git_branches
	# REF: https://web.archive.org/web/https://stackoverflow.com/questions/12370714/git-how-do-i-list-only-local-branches/40122019#40122019
	git_branches="$(git for-each-ref --format='%(refname:short)' refs/heads/)"
	# Get the current git branch.
	local git_current_branch
	git_current_branch="$(git branch | grep '^\*' | tr -d '^\* ')"
	# Remove all branches named master, main, or init.
	local git_branches_filtered
	git_branches_filtered="$(echo "${git_branches}" | tr ' ' '\n' | egrep --invert-match "(^\*|master|main|init|${git_current_branch})")"

	# Remove the branches.
	echo >&2 "removing git branches."
	echo "${git_branches_filtered}" | tr ' ' '\n' | xargs -I{} git branch --delete --force '{}'
	if (( $? != 0 )); then
		echo >&2 "failed to remove git branches."
		return 1
	fi
}

# Reset back to the first commit that is shared with main and the current branch.
#
# Outputs:
#   Nothing.
# Returns:
#   0 on success, non-zero on error.
g8reset() {
	# Get the git status. Will be empty, if there are no unsaved changes.
	local git_status
	git_status="$(git status --short)"

	# If git_status is not empty, then the current git workspace is dirty (has unsaved changes).
	if [[ -n "${git_status}" ]]; then
		>&2 echo "Git workspace is dirty, commit changes before running g8reset. refusing to run."
		return 1
	fi

	# We will be doing a soft reset to the first commit that is shared with main
	# and the current branch.
	# All of the changes will be staged.
	base=$(git merge-base HEAD "${1:-main}")
	>&2 echo "run 'git reset --soft ${base}'?"

	# Prompt to make sure the user wants to run this command.
	if [[ "no" == $(ask "Are you sure?") ]]; then
		>&2 echo "Skipped."
		return
	fi

	# Prompt again to confirm.
	if [[ "no" == $(ask "Are you *really* sure?") ]]; then
		>&2 echo "Skipped."
		return
	fi

	# Run the reset.
	>&2 echo "Running.."
	git reset --soft "${base}"
}

## GITHUB

## GITHUB - FUNCTIONS

# gh_init

# Creates a new GitHub repo.
#
# Outputs:
#   Creates a new GitHub repo, exits if one already exists.
# Returns:
#   0 on success, non-zero on error.
gh_init() {
	# Check to see if gh is available on the path, fail if it's missing.
	if ! command -v gh &> /dev/null; then
		>&2 echo "refusing to run, gh command not found in path"
		return 1
	fi

	# gh --version outputs
	# gh version 2.22.1 (2023-01-27)
	# https://github.com/cli/cli/releases/tag/v2.22.1
	# So, grab the last line, reverse the string, trim everything except the
	# version tag, reverse the string back to normal, finally remove the 'v'.
	# TODO: Do I need the version info for only running specific commands?
	# GH_VERSION="$(gh --version | tail -1 | rev | cut -d'/' -f1 | rev | tr -d 'v')"
	# GH_MAJOR_VERSION="$(echo $GH_VERSION | cut -d'.' -f1)"
	# GH_MINOR_VERSION="$(echo $GH_VERSION | cut -d'.' -f2)"
	# GH_PATCH_VERSION="$(echo $GH_VERSION | cut -d'.' -f3)"

	# Check to see if we are in the top level code directory, fail if we are.
	# if [[ "${PWD}" == "${CODE_WORKSPACE_SRC_GITHUB_COM_JASON_RIDDLE}" ]]; then
	# 	>&2 echo "failed to create github repo, refusing to create repo in top level code directory"
	# 	return 1
	# fi

	# Check to ensure a git repo locally already exists, fail if it does not.
	>&2 echo "checking if git repo in '${PWD}' already exists."
	if ! git rev-parse --git-dir 2>/dev/null; then
		>&2 echo "refusing to create github repo, git repo in '${PWD}' does not exist, run git_init first."
		return 1
	fi

	# Set github_repo_name to current dir.
	local github_repo_name
	github_repo_name=$(basename "$PWD")
	# Create github_repo_https_path from existing vars.
	local github_repo_https_path
	github_repo_https_path="https://${GITHUB_FQDN}/${GITHUB_USER}/${github_repo_name}"

	# Create a private repo using the gh cli tool.
	>&2 echo "creating private github repo."
	gh repo create "${github_repo_https_path}" --private --remote='origin' --source='.'
	if (( $? != 0 )); then
		>&2 echo "failed to create private github repo."
		return 1
	fi

	# Get the head branch for later use.
	>&2 echo "fetching head branch."
	local git_head_branch
	git_head_branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
	if (( $? != 0 )); then
		>&2 echo "failed to fetch the head branch."
		return 1
	fi

	# Push to the head branch.
	>&2 echo "pushing head branch '${git_head_branch}' to origin."
	git push origin "${git_head_branch}"
	if (( $? != 0 )); then
		>&2 echo "failed to push head branch '${git_head_branch}' to origin."
		return 1
	fi

	# Set the upstream for the head branch.
	>&2 echo "setting upstream for head branch '${git_head_branch}' to origin."
	git branch --set-upstream-to "origin/${git_head_branch}" "${git_head_branch}"
	if (( $? != 0 )); then
		>&2 echo "failed to set upstream for head branch '${git_head_branch}' to origin."
		return 1
	fi

	>&2 echo "gitHub repo created at '${github_repo_https_path}'."
}

## GITHUB CLI (GH) (https://github.com/cli/cli)

## GOLANG

## GOLANG - EXPORTS

# Enable module-aware mode when a go.mod file exists.
# REF: https://web.archive.org/web/https://go.dev/blog/go116-module-changes.
export GO111MODULE='auto'

# Set the GOPATH for storing code, building packages, and installing binaries.
# REF: https://web.archive.org/web/https://go.dev/doc/gopath_code
export GOPATH="${HOME}/code"

## GPG / PGP

## GRON (https://github.com/tomnomnom/gron)

## HEROKU

## HOMEBREW

## HOMEBREW - ANALYTICS/TELEMETRY

# Opt out of analytics.
# can also run `brew analytics off`
# REF: https://web.archive.org/web/https://docs.brew.sh/Analytics#opting-out
export HOMEBREW_NO_ANALYTICS='1'

## HOMEBREW - EXPORTS

# Disable running auto update.
export HOMEBREW_NO_AUTO_UPDATE='1'

# Disable running cleanup.
export HOMEBREW_NO_INSTALL_CLEANUP='1'

## HOSTINGER

## HTTPIE (https://github.com/httpie/httpie)

## JAVA

## JO (https://github.com/jpmens/jo)

## JQ (https://github.com/stedolan/jq)

## KUBECTL

## KUBECTL - ALIAS

# Set alias k to kubectl.
alias k='kubectl'
alias kns='kubens'

## KUBERNETES

## L

## MAC

## MAC - EXPORTS

# Suppress the "The default interactive shell is now zsh." message.
# REF: https://web.archive.org/web/https://support.apple.com/en-us/HT208050.
export BASH_SILENCE_DEPRECATION_WARNING='1'

## MACPORTS

## MAKE

## MAVEN

## NIX / NIXOS

## NOMAD

## OPENAI

## OPENSSL

## PIP

## PIPX (https://github.com/pypa/pipx)

## PODMAN (https://github.com/containers/podman)

## PYTHON

## Q

## RENDER.COM

## RIPGREP (RG) (https://github.com/BurntSushi/ripgrep)

## RUBY

## SEARCH

# Search all files for this filename.
#
# Arguments:
#   $1 - Filename, the filename to search for.
# Outputs:
#   TODO.
# Returns:
#   0 on success, non-zero on error.
fname() {
	# Check the number of required arguments are present.
	declare -i numargs="$#"
	if (( numargs != 1 )); then
		>&2 echo "requires 1 argument, found ${numargs} instead."
		>&2 echo "usage: $0 filename"
		exit 1
	fi

	# Parse required arguments then shift to adjust remaining $@ arguments to pass
	# as additional CLI arguments.
	filename="$1"; shift

	# Search through hidden directories and files (--hidden), through
	# symlinks (--follow), exclude .git directory (--exclude='.git') and only
	# search for regular files (--type='file').
	fd --hidden --follow --exclude='.git' --type='file' "${filename}" "$@"
}

## SUBLIME TEXT

## SUBLIME TEXT - ALIAS

# Set alias code to subl.
# Only set if not running on WSL, because I'd rather use vscode on WSL.
if [[ -z "${WSL_DISTRO_NAME}" ]]; then
	alias code='subl -w'
fi

## SUPABASE

## SUPABASE - ALIAS

alias supabase='bunx supabase'

## SYNCTHING

## TAILSCALE

## TERRAFORM

## TERRAFORM CLOUD

## TMP

## TMUX

## TWILIO

## U

## VAGRANT

## VAGRANT - EXPORTS

## VAULT

## VIRTUALENV

## VIM

## WP-CLI (https://github.com/wp-cli/wp-cli)

## XDG

## YOUTUBE-DL

# Wrapper for yt-dlp to download a video.
#
# Returns:
#   0 on success, non-zero on error.
yt_dlp_download_video_wrapper() {
	YT_DLP_CLI_FLAGS=(
		# 1. Download the best video, with extension mp4, and download the best audio,
		#    with extension m4a, and merge both files together.
		# 2. If m4a is not an option, download the best video, with extension mp4.
		--format='bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]'
	)

	YT_DLP_ARIA2C_CLI_FLAGS=(
		## General
		--allow-overwrite='false'
		--always-resume='true'
		--auto-file-renaming='true'
		--auto-save-interval='10'
		--conditional-get='true'
		--continue='true'
		--file-allocation='none'
		--http-accept-gzip='true'
		# 3 kibibytes == 3072 bytes
		--lowest-speed-limit='3K'
		## Download
		--max-concurrent-downloads='12'
		--max-connection-per-server='12'
		--max-download-limit='0'
		--max-overall-download-limit='0'
		--max-overall-upload-limit='256K'
		# 1 mebibytes == 1048576 bytes
		--min-split-size='1M'
		--split='64'
		## Retry
		--max-tries='6'
		--retry-wait='10'
		## Misc
		--socket-recv-buffer-size='2M'
		--summary-interval='0'
	)

	YT_DLP_DOWNLOADER_CLI_FLAGS=(
		--downloader='aria2c'
		--downloader-args="aria2c:'${YT_DLP_ARIA2C_CLI_FLAGS[*]}'"
	)

	# Use nix-shell to download.
	nix-shell --pure --packages yt-dlp aria --run "yt-dlp ${YT_DLP_CLI_FLAGS[*]} ${YT_DLP_DOWNLOADER_CLI_FLAGS[*]} $*"
}

# Download a video.
#
# Returns:
#   0 on success, non-zero on error.
dl() {
	yt_dlp_download_video_wrapper "$@"
}

## YUM

## Z (Jump Around) (https://github.com/rupa/z)

# Source z.sh if the file exists.
if [[ -f "${HOME}/etc/profile.d/z.d/z.sh" ]]; then
	source "${HOME}/etc/profile.d/z.d/z.sh"
fi

## ZIP / UNZIP
