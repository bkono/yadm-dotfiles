# from oh-my-zsh/jump and
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
# Easily jump around the file system by manually adding marks
# marks are stored as symbolic links in the directory $MARKPATH (default $HOME/.marks)
#
# jump FOO: jump to a mark named FOO
# mark FOO: create a mark named FOO
# unmark FOO: delete a mark
# marks: lists all marks
#
export MARKPATH=$HOME/.marks

jump() {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

jj() {
  if ! type fzf >/dev/null 2>&1; then
    echo "fzf not defined"
    return
  fi

  if [ "$1" ]; then
    jump $1
  else
    local mark="$($MARKPATH | fzf | awk '{print $9}')"
    jump "${mark}"
  fi
}

#alias j='jump'

mark() {
  if (($# == 0)); then
    MARK=$(basename "$PWD")
  else
    MARK="$1"
  fi
  if read -q \?"Mark $PWD as ${MARK}? (y/n) "; then
    mkdir -p "$MARKPATH"
    ln -s "$PWD" "$MARKPATH/$MARK"
  fi
}

unmark() {
  rm -i "$MARKPATH/$1"
}

marks() {
  for link in $MARKPATH/*(@); do
    local markname="$fg[cyan]${link:t}$reset_color"
    local markpath="$fg[blue]$(readlink $link)$reset_color"
    printf "%s\t" $markname
    printf "-> %s \t\n" $markpath
  done
}

function _completemarks() {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks jj
compctl -K _completemarks unmark
