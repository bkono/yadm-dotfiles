#!/usr/bin/env zsh

if ! command -v eza &> /dev/null; then
  echo "eza is not installed, skipping plugin"
  return 0
fi

CUR=${0:a:h}
source "$CUR/functions.zsh"
source "$CUR/aliases.zsh"
