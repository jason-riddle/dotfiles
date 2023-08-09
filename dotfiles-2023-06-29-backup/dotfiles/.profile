#!/bin/bash

## BASH

## BASH - ALIAS

alias r="source ${HOME}/.profile"

## BASH - EDITOR

# Set the editor.
export EDITOR='vim'

## BASH - HISTORY

# REF: https://web.archive.org/web/https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows/1292#1292

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

# Using an array, add PATHs and build PATH with build_path.

PATH_BINS=(
	# NIXOS
	"${HOME}/.nix-profile/bin"
	"/nix/var/nix/profiles/default/bin"

	# HOME BIN
	"${HOME}/bin"

	# GOLANG
	"${HOME}/code/bin"
	"/usr/local/go/bin"

	# FLY.IO / FLYCTL
	"${HOME}/.fly/bin"

	# PIPX
	"${HOME}/.local/bin"

	# MACPORTS
	"/opt/local/bin"

	# SNAP
	"/snap/bin"

	# SYSTEM
	"/usr/local/sbin"
	"/usr/local/bin"
	"/usr/sbin"
	"/usr/bin"
	"/sbin"
	"/bin"
)

WSL_PATH_BINS=(
	# WINDOWS
	"/mnt/c/WINDOWS"
	"/mnt/c/WINDOWS/System32"
	"/mnt/c/WINDOWS/System32/OpenSSH"
	"/mnt/c/WINDOWS/System32/Wbem"
	"/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0"

	# JETBRAINS - IDEA
	"/mnt/c/Program Files/JetBrains/IntelliJ IDEA Community Edition 2021.3.1/bin"

	# VSCODE
	"/mnt/c/Users/Jason/AppData/Local/Programs/Microsoft VS Code/bin"
)

# Joins the elements of PATH_BINS into a string.
#
# Requires:
#   None.
# Globals:
#   PATH_BINS.
# Arguments:
#   None.
# Outputs:
#   Outputs PATH_BINS as string.
# Returns:
#   0 on success, non-zero on error.
build_path() {
	# Concat PATH_BINS into a string, delimited by ':'. Use subshell to avoid
	# modifying IFS.
	#
	# REF: https://web.archive.org/web/https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash/53050617#53050617
	# (IFS=':'; printf '%s' "${PATH_BINS[*]}")
	(IFS=':'; printf '%s' "${PATH_BINS[*]}"; printf ':'; printf '%s' "${WSL_PATH_BINS[*]}")
	echo
}

# Set the PATH environment variable.
PATH="$(build_path)"
export PATH

## BASH - PROMPT

# Outputs the current git branch formatted for use in PS1.
#
# Requires:
#   git (https://web.archive.org/web/https://git-scm.com/book/en/v2/Getting-Started-Installing-Git/)
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   Outputs the current git branch, outputs nothing if not on a git branch.
# Returns:
#   0 on success, non-zero on error.
ps1_git_branch() {
	local git_branch
	# Get the current git branch, strip away extra formatting.
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

## CODE WORKSPACE - EXPORTS

# Various CODE_WORKSPACE env vars to use in functions below.
export CODE_WORKSPACE="${HOME}/code"
export CODE_WORKSPACE_BIN="${CODE_WORKSPACE}/bin"
export CODE_WORKSPACE_SRC="${CODE_WORKSPACE}/src"
export CODE_WORKSPACE_SRC_GITHUB_COM_JASON_RIDDLE="${CODE_WORKSPACE}/src/github.com/jason-riddle"

## GITHUB REPO - EXPORTS

# Various GITHUB env vars to use in functions below.
export GITHUB_FQDN='github.com'
export GITHUB_USER='jason-riddle'

## SECRETS - EXPORTS

# Various SECRETS env vars to use in functions below.
export SECRETS="${HOME}/Documents/secrets"

## ---

## 1PASSWORD CLI (OP)

## 1PASSWORD CLI (OP) - EXPORTS

# Set the default account.
export OP_ACCOUNT='my.1password.com'

## 1PASSWORD CLI (OP) - FUNCTIONS

# Sign into 1password.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.
signin() {
	eval "$(op signin)"
}

## AGE (https://github.com/FiloSottile/age)

## ANSIBLE

## ANSIBLE-GALAXY

## ANSIBLE-VAULT

## ANSIBLE-VAULT - EXPORTS

# Set the ansible vault password file to automatically encrypt and decrypt
# without the password.
export ANSIBLE_VAULT_PASSWORD_FILE="${HOME}/Documents/ansible-vault-password/pw/pw.txt"

## APT

## ARIA2C

## AWSCLI

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

# TODO add commands

# REF: https://web.archive.org/web/https://superuser.com/questions/370388/simple-built-in-way-to-encrypt-and-decrypt-a-file-on-a-mac-via-command-line
# encrypt: openssl enc aes-256-cbc -salt -in file.txt -out file.enc
# decrypt: openssl enc -d -aes-256-cbc -in file.enc -out file.txt

## FD (https://github.com/sharkdp/fd)

## FFMPEG

## FLY.IO / FLYCTL

## FZF (https://github.com/junegunn/fzf)

## FZF - EXPORTS

# -i                 - Case-insensitive match
# --layout='reverse' - Show the layout on the bottom instead of the top
# --preview          - Show a preview of a file.
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

# Source fzf keybindings (MacPorts).
if [[ -f "/opt/local/share/fzf/shell/key-bindings.bash" ]]; then
	source "/opt/local/share/fzf/shell/key-bindings.bash"
fi

# Source fzf fuzzy auto-completion (MacPorts).
if [[ -f "/opt/local/share/fzf/shell/completion.bash" ]]; then
	source "/opt/local/share/fzf/shell/completion.bash"
fi

# Source fzf keybindings (Debian/Ubuntu).
# REF: https://web.archive.org/web/20230312231653/https://github.com/junegunn/fzf/issues/1866#issuecomment-585176100
if [[ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]]; then
	source "/usr/share/doc/fzf/examples/key-bindings.bash"
fi

# Source fzf fuzzy auto-completion (Debian/Ubuntu).
if [[ -f "/usr/share/bash-completion/completions/fzf" ]]; then
	source "/usr/share/bash-completion/completions/fzf"
fi

## GCLOUD / GCP

## GHQ (https://github.com/x-motemen/ghq)

## GHQ - EXPORTS

# Set the ghq root for cloning.
# REF: https://web.archive.org/web/20230202005519/https://github.com/x-motemen/ghq#environment-variables
export GHQ_ROOT="${CODE_WORKSPACE_SRC}"

## GIT

## GIT - ALIAS

# Some helpful aliases.
alias g='git'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gp='git push'

## GIT - FUNCTIONS

# Run git add && git commit -m "Update".
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.
gac() {
	# Check to see if git is available on the path, fail if it's missing.
	if ! command -v git &> /dev/null; then
		echo >&2 "refusing to run, git command not found in path"
		return 1
	fi

	git add -A && git commit -m "Update"
}

# Run git add && git commit -m "Update" && git push.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.
gacup() {
	# Check to see if git is available on the path, fail if it's missing.
	if ! command -v git &> /dev/null; then
		echo >&2 "refusing to run, git command not found in path"
		return 1
	fi

	git add -A && git commit -m "Update" && git push
}

# Deletes all local branches except master, main, and init.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.
gbr() {
	# Check to see if git is available on the path, fail if it's missing.
	if ! command -v git &> /dev/null; then
		echo >&2 "refusing to run, git command not found in path"
		return 1
	fi

	local git_branches
	# REF: https://web.archive.org/web/https://stackoverflow.com/questions/12370714/git-how-do-i-list-only-local-branches/40122019#40122019
	git_branches="$(git for-each-ref --format='%(refname:short)' refs/heads/)"
	local git_current_branch
	git_current_branch="$(git branch | grep '^\*' | tr -d '^\* ')"
	local git_branches_filtered
	git_branches_filtered="$(echo "${git_branches}" | tr ' ' '\n' | egrep --invert-match "(^\*|master|main|init|${git_current_branch})")"

	echo >&2 "removing git branches."
	echo "${git_branches_filtered}" | tr ' ' '\n' | xargs -I{} git branch --delete --force '{}'
	if (( $? != 0 )); then
		echo >&2 "failed to remove git branches."
		return 1
	fi
}

# Creates a new git repo.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
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
LOG_LEVEL=VERBOSE
SUPPRESS_POSSUM=true
VALIDATE_ALL_CODEBASE=true
VALIDATE_GITHUB_ACTIONS=false
VALIDATE_MARKDOWN=false
VALIDATE_NATURAL_LANGUAGE=false
VALIDATE_TERRAFORM_TERRASCAN=false
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

# Creates a new GitHub repo.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
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

## HOMEBREW - ANALYTICS

# Opt out of analytics.
# can also run `brew analytics off`
# REF: https://web.archive.org/web/https://docs.brew.sh/Analytics#opting-out
export HOMEBREW_NO_ANALYTICS='1'

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

# TODO: Add alias for updating ports with 'port selfupdate'.

# TODO: Add alias for upgrading ports with 'port upgrade outdated'.

# CHEAT SHEET REF: https://web.archive.org/web/https://kapeli.com/cheat_sheets/MacPorts.docset/Contents/Resources/Documents/index

## MAKE

# Set alias code to make.
alias m='make'

## MAVEN

## NIX / NIXOS

# TODO: how to update nix

# First, check the current version
# Command
# nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'
#
# Output
# "22.11pre405756.21de2b973f9"

# List channels
# Command
# sudo nix-channel --list
#
# Output
# nixpkgs https://nixos.org/channels/nixpkgs-unstable

# Update nixpkgs channel
# Command
# sudo nix-channel --update nixpkgs
#
# Output
# warning: $HOME ('/Users/jason') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
# unpacking channels...
# warning: $HOME ('/Users/jason') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
# unpacking channels...


# Get the version
# Command
# nix-instantiate --eval --expr '(import <nixpkgs> {}).lib.version'
#
# Output
# "23.05pre458934.3ad64d9e2d5"

# Review release timestamp
# https://releases.nixos.org/nixpkgs/nixpkgs-23.05pre458934.3ad64d9e2d5

# Install the latest version of a package
# Command
# nix-env --install --attr nixpkgs.yt-dlp
#
# Output
# replacing old 'yt-dlp-2022.9.1'
# installing 'yt-dlp-2023.3.4'

# Install an older version
# 1. Find the package on here: https://web.archive.org/web/https://lazamar.co.uk/nix-versions/
# 2. Click on the sha sum.
# 3. Run nix-env and specify the file, example below
# Command
# nix-env --install --attr yt-dlp --file https://github.com/NixOS/nixpkgs/archive/ee01de29d2f58d56b1be4ae24c24bd91c5380cea.tar.gz
#
# Output
# replacing old 'yt-dlp-2023.3.4'
# installing 'yt-dlp-2022.9.1'

# Print the version of the package
# Command
# nix-instantiate --eval --expr '(import <nixpkgs> {}).yt-dlp.version'
#
# Output
# "2023.3.4"

# Rollback to previous nixpkgs if necessary
# Command
# sudo nix-channel --rollback
#
# Output
# switching profile from version 2 to 1

# Rollforward if necessary
# Command
# sudo nix-channel --rollback 2
#
# Output
# switching profile from version 1 to 2

# View older versions of packages here
# https://lazamar.co.uk/nix-versions

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
# Only set if not running on WSL, this is because I'd rather use vscode on WSL.
if [[ -z "${WSL_DISTRO_NAME}" ]]; then
	alias code='subl'
fi

## SYNCTHING

## TAILSCALE

## TAX PREPARATION

# Zip and encrypt taxes.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.
preptaxes() {
	TAX_YEAR="2022"
	TAX_ENTITY="Jason Riddle"

	# Files
	TAX_FILES="${HOME}/Nextcloud/Files/Taxes/${TAX_YEAR} Taxes"
	# Documents
	TAX_FILES_DOCUMENTS_DIR="${TAX_FILES}/${TAX_ENTITY}/${TAX_YEAR} Tax Documents"
	# Return
	TAX_FILES_RETURN_DIR="${TAX_FILES}/${TAX_ENTITY}/${TAX_YEAR} Tax Return"

	# Tmp base
	TIMESTAMP="$(date +'%s')"
	TIME_HOUR_MINUTE="$(date +'%H_%M')"
	TMP_BASE_DIR="/tmp/Taxes/${TAX_YEAR}/${TIME_HOUR_MINUTE}-${TIMESTAMP}"
	TMP_BASE_FILES_IN_DIR="${TMP_BASE_DIR}/FILES_IN"
	TMP_BASE_FILES_OUT_DIR="${TMP_BASE_DIR}/FILES_OUT"
	mkdir -p "${TMP_BASE_FILES_IN_DIR}"
	mkdir -p "${TMP_BASE_FILES_OUT_DIR}"

	# Workspace
	TAX_WORKSPACE_NAME="${TAX_YEAR} ${TAX_ENTITY} Taxes"

	echo >&2 "Pre Zip - Creating Tax Workspace FILES_IN Dir."
	TAX_WORKSPACE_FILES_IN_DIR="$(mktemp -d "${TMP_BASE_FILES_IN_DIR}/${TAX_WORKSPACE_NAME} FILES_IN.XXXXXXXXX")"
	echo >&2 "Pre Zip - Created Tax Workspace FILES_IN Dir at '${TAX_WORKSPACE_FILES_IN_DIR}'."
	echo >&2

	echo >&2 "Pre Zip - Creating Tax Workspace FILES_OUT Dir."
	TAX_WORKSPACE_FILES_OUT_DIR="$(mktemp -d "${TMP_BASE_FILES_OUT_DIR}/${TAX_WORKSPACE_NAME} FILES_OUT.XXXXXXXXX")"
	echo >&2 "Pre Zip - Created Tax Workspace FILES_OUT Dir at '${TAX_WORKSPACE_FILES_OUT_DIR}'."
	echo >&2

	echo >&2 "Pre Zip - Copying Tax Documents to Tax Workspace FILES_IN Dir."
	echo cp -r "${TAX_FILES_DOCUMENTS_DIR}" "${TAX_WORKSPACE_FILES_IN_DIR}"
	cp -r "${TAX_FILES_DOCUMENTS_DIR}" "${TAX_WORKSPACE_FILES_IN_DIR}"
	echo >&2 "Pre Zip - Copied Tax Documents to Tax Workspace FILES_IN Dir."
	echo >&2

	echo >&2 "Pre Zip - Copying Tax Return to Tax Workspace FILES_IN Dir."
	echo cp -r "${TAX_FILES_RETURN_DIR}" "${TAX_WORKSPACE_FILES_IN_DIR}"
	cp -r "${TAX_FILES_RETURN_DIR}" "${TAX_WORKSPACE_FILES_IN_DIR}"
	echo >&2 "Pre Zip - Copied Tax Return to Tax Workspace FILES_IN Dir."
	echo >&2

	echo >&2 "Pre Zip - Listing the Contents of Tax Workspace FILES_IN Dir."
	ls -al "${TAX_WORKSPACE_FILES_IN_DIR}" | grep -v total
	echo >&2

	echo >&2 "Pre Zip - Listing the Contents of Tax Workspace FILES_OUT Dir."
	ls -al "${TAX_WORKSPACE_FILES_OUT_DIR}" | grep -v total
	echo >&2

	TAX_WORKSPACE_FILES_OUT_ZIP_FILE="${TAX_WORKSPACE_FILES_OUT_DIR}/${TAX_WORKSPACE_NAME}.zip"

	echo >&2 "Pre Zip - cd to FILES_IN Dir."
	echo pushd "${TAX_WORKSPACE_FILES_IN_DIR}"
	pushd "${TAX_WORKSPACE_FILES_IN_DIR}"
	echo >&2

	echo >&2 "Zip - Zipping and Encrypting Contents of Tax Workspace FILES_IN Dir to FILES_OUT Zip File."
	echo zip -e -r "${TAX_WORKSPACE_FILES_OUT_ZIP_FILE}" . -x "*.DS_Store*" \> /dev/null
	zip -e -r "${TAX_WORKSPACE_FILES_OUT_ZIP_FILE}" . -x "*.DS_Store*" > /dev/null
	echo >&2 "Zip - Zipped and Encrypted Contents of Tax Workspace FILES_IN Dir to FILES_OUT Zip File."
	echo >&2

	echo >&2 "Post Zip - cd back to previous Dir."
	echo popd
	popd
	echo >&2

	echo >&2 "Post Zip - Listing the Contents of Tax Workspace FILES_IN Dir."
	ls -al "${TAX_WORKSPACE_FILES_IN_DIR}" | grep -v total
	echo >&2

	echo >&2 "Post Zip - Listing the Contents of Tax Workspace FILES_OUT Dir."
	ls -al "${TAX_WORKSPACE_FILES_OUT_DIR}" | grep -v total
	echo >&2

	echo >&2 "Post Zip - Listing the Contents of Tax Workspace FILES_OUT Zip File."
	unzip -l "${TAX_WORKSPACE_FILES_OUT_ZIP_FILE}" | grep -v Archive
	echo >&2

	echo >&2 "Post Zip - Zipping Finished."
	echo >&2 "Post Zip - Zipped Tax Workspace at '${TAX_WORKSPACE_FILES_OUT_DIR}'."
	echo >&2 "Post Zip - Opening '${TAX_WORKSPACE_FILES_OUT_DIR}' in 5 Seconds."
	sleep 5

	echo open "${TAX_WORKSPACE_FILES_OUT_DIR}"
	open "${TAX_WORKSPACE_FILES_OUT_DIR}"
}

## TERRAFORM

## TERRAFORM CLOUD

# TODO: Command helps to gather, zip, and encrypt.

## TMP

# TODO What the best cross platform script for this?

# REF: https://web.archive.org/web/https://stackoverflow.com/questions/10982911/creating-temporary-files-in-bash/10983009
# mydir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")

# REF: https://web.archive.org/web/https://stackoverflow.com/questions/31396985/why-is-mktemp-on-os-x-broken-with-a-command-that-worked-on-linux/31397073
# mktemp -d "${TMPDIR:-/tmp}/zombie.XXXXXXXXX"

# REF: https://web.archive.org/web/https://unix.stackexchange.com/questions/30091/fix-or-alternative-for-mktemp-in-os-x/84980
# mytmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

## TMUX

## TWILIO

## U

## VAGRANT

## VAGRANT - EXPORTS

# Enable WSL.
# REF: https://developer.hashicorp.com/vagrant/docs/other/wsl
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

## VAULT

## VIRTUALENV

## VIM

## WP-CLI (https://github.com/wp-cli/wp-cli)

## XDG

## YOUTUBE-DL

# Wrapper for yt-dlp to download a video.
#
# Requires:
#   TODO.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
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

# Wrapper for yt-dlp to download a video and convert to audio.
#
# Requires:
#   TODO.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   None.
# Returns:
#   0 on success, non-zero on error.
yt_dlp_download_music_wrapper() {
	YT_DLP_CLI_FLAGS=(
		# Download the best mp3 audio.
		# REF: https://web.archive.org/web/https://askubuntu.com/questions/634584/how-to-download-youtube-videos-as-a-best-quality-audio-mp3-using-youtube-dl/634622#634622
		--format='bestaudio'
		--extract-audio
		--audio-format='mp3'
		--audio-quality='0'
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
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   Downloads a video.
# Returns:
#   0 on success, non-zero on error.
dl() {
	yt_dlp_download_video_wrapper "$@"
}

# Download a video and convert to audio.
#
# Requires:
#   None.
# Globals:
#   None.
# Arguments:
#   None.
# Outputs:
#   Downloads a video.
# Returns:
#   0 on success, non-zero on error.
dlm() {
	yt_dlp_download_music_wrapper "$@"
}

## YUM

## Z (Jump Around) (https://github.com/rupa/z)

# Source z.sh if the file exists.
if [[ -f "${HOME}/etc/profile.d/z.d/z.sh" ]]; then
	source "${HOME}/etc/profile.d/z.d/z.sh"
fi

## ZIP / UNZIP

# TODO: What's the best approach for this? Using plain zip or mac ditto?
# https://web.archive.org/web/https://superuser.com/questions/505034/compress-files-from-os-x-terminal
# https://web.archive.org/web/https://stackoverflow.com/questions/10738505/mac-os-x-compress-option-vs-command-line-zip-why-do-they-produce-different-re
