#!/usr/bin/env zsh

function git_main_branch() {
  if [[ $(git rev-parse --git-dir 2> /dev/null) ]]; then
    default_branch=$(git config --get init.defaultBranch)
    if $(git show-ref -q --verify refs/heads/$default_branch); then
      echo $default_branch
    elif $(git show-ref -q --verify refs/heads/main); then
      echo "main"
    else # fallback to master
      echo "master"
    fi
  fi
}

unalias gcom 2>/dev/null
function gcom() {
  git checkout $(git_main_branch)
}

unalias gdom 2>/dev/null
function gdom() {
  git diff origin/$(git_main_branch)
}

unalias gdm 2>/dev/null
function gdm() {
  git diff $(git_main_branch) $@
}

unalias grbm 2>/dev/null
function grbm() {
  git rebase -i $(git_main_branch)
}

unalias g 2>/dev/null # yes I know this is a dirty play
function g() {
  cmd=`which hub`
  if [[ ! -a $cmd ]] ; then
    cmd=`which git`
  fi
  if [[ $# > 0 ]]; then
    $cmd $@
  else
    $cmd status
  fi
}

# Complete g like git
compdef g=git

function gbsu() {
  branch=$(git symbolic-ref --short -q HEAD)
  if [[ $# > 0 ]]
  then
    target=$1
  else
    target=$branch
  fi

  git branch --set-upstream-to=origin/$target $branch
}

function gclmkd() {
  repo=$1
  arr=(${(s:/:)repo})
  directory=$arr[1]

  mkdir $directory && cd $directory
  gh repo clone $repo
}

function gwtn() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: gwtn <branch-name>"
    echo "Example: gwtn feat/new-thing"
    return 1
  fi

  branch_name=$1
  
  # Convert branch name to kebab case for worktree directory (replace slashes with hyphens)
  worktree_name=${branch_name//\//-}
  
  # Get git root directory
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$git_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi
  
  # Check if .beads directory exists to determine which worktree command to use
  if [[ -d "$git_root/.beads" ]]; then
    use_bd=true
  else
    use_bd=false
  fi
  
  # Get project name from git root directory name
  project_name=$(basename "$git_root")
  
  # Worktree path is one level up from git root, in wt folder, prefixed with project name
  worktree_path="$git_root/../wt/$project_name-$worktree_name"
  
  # Create the worktree
  echo "Creating worktree at ../wt/$project_name-$worktree_name with branch $branch_name..."
  if [[ "$use_bd" == true ]]; then
    bd worktree create "../wt/$project_name-$worktree_name" --branch "$branch_name"
  else
    git worktree add "../wt/$project_name-$worktree_name" -b "$branch_name"
  fi
  
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create worktree"
    return 1
  fi
  
  # Copy config files if they exist
  echo "Copying config files..."
  
  if [[ -f "$git_root/.env" ]]; then
    cp "$git_root/.env" "$worktree_path/.env"
    echo "  ✓ Copied .env"
  fi
  
  if [[ -f "$git_root/.mise.local.toml" ]]; then
    cp "$git_root/.mise.local.toml" "$worktree_path/.mise.local.toml"
    echo "  ✓ Copied .mise.local.toml"
  fi
  
  if [[ -d "$git_root/.codex" ]]; then
    mkdir -p "$worktree_path/.codex"
    cp -r "$git_root/.codex/." "$worktree_path/.codex/"
    echo "  ✓ Merged .codex/"
  fi
  
  if [[ -d "$git_root/.claude" ]]; then
    mkdir -p "$worktree_path/.claude"
    cp -r "$git_root/.claude/." "$worktree_path/.claude/"
    echo "  ✓ Merged .claude/"
  fi
  
  echo "Done! Worktree created at ../wt/$project_name-$worktree_name"
  echo "To switch: cd ../wt/$project_name-$worktree_name"
}

function gwtd() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: gwtd <branch-name>"
    echo "Example: gwtd feat/new-thing"
    return 1
  fi

  branch_name=$1
  
  # Convert branch name to kebab case for worktree directory (replace slashes with hyphens)
  worktree_name=${branch_name//\//-}
  
  # Get git root directory
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$git_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi
  
  # Check if .beads directory exists to determine which worktree command to use
  if [[ -d "$git_root/.beads" ]]; then
    use_bd=true
  else
    use_bd=false
  fi
  
  # Get project name from git root directory name
  project_name=$(basename "$git_root")
  
  # Worktree path is one level up from git root, in wt folder, prefixed with project name
  worktree_path="$git_root/../wt/$project_name-$worktree_name"
  
  # Check if worktree exists
  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: Worktree not found at ../wt/$project_name-$worktree_name"
    return 1
  fi
  
  # Remove the worktree
  echo "Removing worktree at ../wt/$project_name-$worktree_name..."
  if [[ "$use_bd" == true ]]; then
    bd worktree remove "$worktree_path"
  else
    git worktree remove "$worktree_path"
  fi
  
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to remove worktree"
    return 1
  fi
  
  echo "  ✓ Worktree removed"
  
  # Check if local branch exists and delete it
  if git show-ref -q --verify refs/heads/$branch_name; then
    echo "Deleting local branch $branch_name..."
    git branch -D "$branch_name"
    if [[ $? -eq 0 ]]; then
      echo "  ✓ Local branch deleted"
    else
      echo "  ⚠ Failed to delete local branch (may be checked out elsewhere)"
    fi
  else
    echo "  ℹ Local branch $branch_name does not exist"
  fi
  
  echo "Done! Worktree and branch cleanup complete"
}


HASH="%C(yellow)%h%Creset"
RELATIVE_TIME="%Cgreen(%ar)%Creset"
AUTHOR="%C(bold blue)<%an>%Creset"
REFS="%C(bold red)%d%Creset"
SUBJECT="%s"

FORMAT="$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"

ANSI_BLACK='\033[30m'
ANSI_BLACK_BOLD='\033[0;30;1m'
ANSI_RED='\033[31m'
ANSI_RED_BOLD='\033[0;31;1m'
ANSI_GREEN='\033[32m'
ANSI_GREEN_BOLD='\033[0;32;1m'
ANSI_YELLOW='\033[33m'
ANSI_YELLOW_BOLD='\033[0;33;1m'
ANSI_BLUE='\033[34m'
ANSI_BLUE_BOLD='\033[0;34;1m'
ANSI_MAGENTA='\033[35m'
ANSI_MAGENTA_BOLD='\033[0;35;1m'
ANSI_CYAN='\033[36m'
ANSI_CYAN_BOLD='\033[0;36;1m'
ANSI_WHITE='\033[37m'
ANSI_WHITE_BOLD='\033[0;37;1m'
ANSI_RESET='\033[0m'


show_git_head() {
  pretty_git_log -1
    git show -p --pretty="tformat:"
}

pretty_git_log() {
  git log --graph --pretty="tformat:${FORMAT}" $* |
# Replace (2 years ago) with (2 years)
    sed -Ee 's/(^[^<]*) ago\)/\1)/' |
# Replace (2 years, 5 months) with (2 years)
    sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?\)/\1)/' |
# Line columns up based on } delimiter
    column -s '}' -t |
# Color merge commits specially
    sed -Ee "s/(Merge branch .* into .*$)/$(printf $ANSI_RED)\1$(printf $ANSI_RESET)/" |
# Page only if we need to
    less -FXRS
}

git_fix_date() {
  GIT_COMMITTER_DATE="`date`" git commit --amend --date "`date`"
}
