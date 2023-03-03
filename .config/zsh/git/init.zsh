#!/usr/bin/env zsh

CUR=${0:a:h}
source "$CUR/functions.zsh"
source "$CUR/aliases.zsh"

export GPG_TTY=$(tty)

# handle a .gitconfig not present
if [ ! -e "$HOME/.gitconfig.local" ]; then
  printf "No gitconfig.local found. Let's build you one.\n"
  printf "Name: "
  read name
  printf "Email: "
  read email
  echo "[user]\n\tname = $name\n\temail = $email" >> $HOME/.gitconfig.local
  printf "~/.gitconfig.local written.\n"
fi
