#!/usr/bin/env zsh

function venv-here() {
  # you could just use 'layout python' here for 2.7.x
  echo "layout python3" >.envrc
  echo "ln -s .direnv/\$(basename \$VIRTUAL_ENV)/ .env" >>.envrc
}
