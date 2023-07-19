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

## CODE WORKSPACE - EXPORTS

## GITHUB REPO - EXPORTS

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

## GITHUB

## GITHUB - FUNCTIONS

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
