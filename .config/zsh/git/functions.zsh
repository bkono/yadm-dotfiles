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
