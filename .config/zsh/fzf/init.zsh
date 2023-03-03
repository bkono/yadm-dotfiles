#!/usr/bin/env zsh

export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1"
#
# fd based search
# export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude .git'

# rg based search, don't do this without a good .rgignore at the root to dodge Library/CloudStorage etc
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-messages"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --exclude ".git" . "$1"
}

CUR=${0:a:h}
source "$CUR/functions.zsh"
source "$CUR/aliases.zsh"
