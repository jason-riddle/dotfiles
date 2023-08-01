#!/usr/bin/env bash

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

## BASH - PATH

PATH_BINS=(
	# NixOS
	"${HOME}/.nix-profile/bin"
	"/nix/var/nix/profiles/default/bin"

	# Home
	"${HOME}/bin"

	# Homebrew
	"/opt/homebrew/bin"

	# Gitbin
	"${HOME}/gitbin"

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
	echo " [${git_branch}]"
}

# Set the prompt.
# $USER@$HOSTNAME $PWD
export PS1="\u@\h \w\$(ps1_git_branch) \$ "

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

## GCLOUD / GCP

## GHQ (https://github.com/x-motemen/ghq)

## GHQ - EXPORTS

## GIT

## GIT - ALIAS

# Some helpful aliases.
alias g='git'
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
		echo >&2 "refusing to run, git command not found in path"
		return 1
	fi

	# TODO: Do I need the version info for only running specific commands?
	# GIT_VERSION="$(git --version | rev | cut -d' ' -f1 | rev)"
	# GIT_MAJOR_VERSION="$(echo $GIT_VERSION | cut -d'.' -f1)"
	# GIT_MINOR_VERSION="$(echo $GIT_VERSION | cut -d'.' -f2)"
	# GIT_PATCH_VERSION="$(echo $GIT_VERSION | cut -d'.' -f3)"

	# Check to see if we are in the top level code directory, fail if we are.
	# if [[ "${PWD}" == "${CODE_WORKSPACE_SRC_GITHUB_COM_JASON_RIDDLE}" ]]; then
	# 	echo >&2 "failed to create git repo, refusing to create repo in top level code directory"
	# 	return 1
	# fi

	# Check to see if a repo already exists, fail if it does.
	echo >&2 "checking if git repo in '${PWD}' already exists."
	if git rev-parse --git-dir 2>/dev/null; then
		echo >&2 "refusing to create repo, git repo in '${PWD}' already exists"
		return 1
	fi

	# We are not in a git repo, so create one.
	echo >&2 "running 'git init' in '${PWD}'"
	git init 2>/dev/null
	if (( $? != 0 )); then
		echo >&2 "failed to run git init."
		return 1
	fi

	# Set the default branch. Read $(git config init.defaultBranch) or use main
	# as default
	local git_default_branch
	git_default_branch="$(git config init.defaultBranch 2>/dev/null || echo 'main')"

	# Set the head branch for the local git repo.
	echo >&2 "setting head branch to ${git_default_branch}."
	git symbolic-ref HEAD "refs/heads/${git_default_branch}"
	if (( $? != 0 )); then
		echo >&2 "setting head branch failed."
		return 1
	fi

	# Create a .gitignore file.
	echo >&2 "creating .gitignore file."
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
	echo >&2 "creating .github/dependabot.yml file."
	mkdir -p .github
	cat <<EOF >.github/dependabot.yml
---
# REF: https://web.archive.org/web/https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file
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
  - package-ecosystem: maven
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: pip
    directory: /
    schedule:
      interval: monthly
  - package-ecosystem: terraform
    directory: /
    schedule:
      interval: monthly
EOF

	# TODO: Should this be created here or in github_init?
	# Super-linter is a GitHub mega linter for linting multiple languages.
	echo >&2 "creating .github/env/super-linter.env file."
	mkdir -p .github/env
	cat <<EOF >.github/env/super-linter.env
DEFAULT_BRANCH=main
FILTER_REGEX_EXCLUDE=(charts)
LOG_LEVEL=VERBOSE
SUPPRESS_POSSUM=true
VALIDATE_ALL_CODEBASE=true
VALIDATE_GITHUB_ACTIONS=false
VALIDATE_JSCPD=false
VALIDATE_KUBERNETES_KUBECONFORM=false
VALIDATE_MARKDOWN=false
VALIDATE_NATURAL_LANGUAGE=false
VALIDATE_TERRAFORM_TERRASCAN=false
VALIDATE_TERRAFORM_TFLINT=false
EOF

	# TODO: Should this be created here or in github_init?
	# Super-linter is a GitHub mega linter for linting multiple languages.
	echo >&2 "creating .github/workflows/ci-super-linter.yml file."
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
        uses: actions/checkout@v3

      - name: Read env vars from super-linter.env.
        run: |
          cat .github/env/super-linter.env >> "\$GITHUB_ENV"

      - name: Lint code.
        uses: super-linter/super-linter/slim@v5
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
EOF

	# Create the initial commit.
	echo >&2 "creating initial commit."
	git add --all && git commit --message "Initial Commit"
	if (( $? != 0 )); then
		echo >&2 "failed to create initial commit."
		return 1
	fi

	echo >&2 "git repo created."
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
		echo >&2 "refusing to run, gh command not found in path"
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
	# 	echo >&2 "failed to create github repo, refusing to create repo in top level code directory"
	# 	return 1
	# fi

	# Check to ensure a git repo locally already exists, fail if it does not.
	echo >&2 "checking if git repo in '${PWD}' already exists."
	if ! git rev-parse --git-dir 2>/dev/null; then
		echo >&2 "refusing to create github repo, git repo in '${PWD}' does not exist, run git_init first."
		return 1
	fi

	# Set github_repo_name to current dir.
	local github_repo_name
	github_repo_name=$(basename "$PWD")
	# Create github_repo_https_path from existing vars.
	local github_repo_https_path
	github_repo_https_path="https://${GITHUB_FQDN}/${GITHUB_USER}/${github_repo_name}"

	# Create a private repo using the gh cli tool.
	echo >&2 "creating private github repo."
	gh repo create "${github_repo_https_path}" --private --remote='origin' --source='.'
	if (( $? != 0 )); then
		echo >&2 "failed to create private github repo."
		return 1
	fi

	# Get the head branch for later use.
	echo >&2 "fetching head branch."
	local git_head_branch
	git_head_branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
	if (( $? != 0 )); then
		echo >&2 "failed to fetch the head branch."
		return 1
	fi

	# Push to the head branch.
	echo >&2 "pushing head branch '${git_head_branch}' to origin."
	git push origin "${git_head_branch}"
	if (( $? != 0 )); then
		echo >&2 "failed to push head branch '${git_head_branch}' to origin."
		return 1
	fi

	# Set the upstream for the head branch.
	echo >&2 "setting upstream for head branch '${git_head_branch}' to origin."
	git branch --set-upstream-to "origin/${git_head_branch}" "${git_head_branch}"
	if (( $? != 0 )); then
		echo >&2 "failed to set upstream for head branch '${git_head_branch}' to origin."
		return 1
	fi

	echo >&2 "gitHub repo created at '${github_repo_https_path}'."
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

## SUBLIME TEXT

## SUBLIME TEXT - ALIAS

# Set alias code to subl.
# Only set if not running on WSL, because I'd rather use vscode on WSL.
if [[ -z "${WSL_DISTRO_NAME}" ]]; then
	alias code='subl -w'
fi

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

## YUM

## Z (Jump Around) (https://github.com/rupa/z)

# Source z.sh if the file exists.
if [[ -f "${HOME}/etc/profile.d/z.d/z.sh" ]]; then
	source "${HOME}/etc/profile.d/z.d/z.sh"
fi

## ZIP / UNZIP
