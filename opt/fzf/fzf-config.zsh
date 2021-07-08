#!/usr/bin/env zsh

# References
# - https://medium.com/better-programming/boost-your-command-line-productivity-with-fuzzy-finder-985aa162ba5d
# - https://mike.place/2017/fzf-fd/
# - https://www.mankier.com/1/fzf
# - https://github.com/fossabot/dotdrop/blob/7662b92906621a4ede4a1297a574ffda26da4f0c/dotfiles/zsh/config/env.zsh#L46-L47

# Default command to use when input is tty
# FZF_DEFAULT_COMMAND is for plain 'fzf'
export FZF_DEFAULT_COMMAND="fd --follow --hidden --exclude .git --type file"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --follow --hidden --exclude .git --type directory"

export FZF_DEFAULT_OPTS="
	-i
	--height=45%
	--layout=reverse
	--border
	--multi
	--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
	--prompt='∼ ' --pointer='>' --marker='✓'
	--bind '?:toggle-preview'
	--header '? - toggle preview'
"

# Use ** to trigger autocomplete
# Examples: cd **<TAB>, unset **<TAB>, ssh **<TAB>
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf autocomplete command
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
# Examples: vim **<TAB>, cat **<TAB>
_fzf_compgen_path() {
	fd --hidden --follow --exclude .git --type file . "$1"
}

# Use fd to generate the list for directory completion
# Examples: cd **<TAB>, pushd **<TAB>
_fzf_compgen_dir() {
	fd --hidden --follow --exclude .git --type directory . "$1"
}
