# For sudo-ing aliases
# https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '

# OSX Specific
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='gls'

  # Network Utils
  alias bouncenet='sudo ifconfig en0 down;sudo ifconfig en0 up'
  alias checkvpn='route get 0/1 && route get 128.0/1'
  alias flushdns='sudo killall -HUP mDNSResponder'
  alias wifi='networksetup -setairportpower en0'
fi

if type "mmake" >/dev/null; then
  alias make=mmake
fi

alias -g G2='| grep -C2'
alias -g G='| grep'
alias -g L='| wc -l'
alias -g M='| more'
alias -g ONE="| awk '{ print \$1}'"
alias aptg='sudo apt-get install'
alias c='cd'
alias e=$EDITOR
alias l='ls -AlhF --group-directories-first --color=auto'
alias ll='ls -al --color=auto'
alias md='mkdir -p'
alias remore='!! | more'
alias retag='ctags -Ra'
alias sort='gsort'
alias sz='source ~/.zshrc'
alias tlf="tail -f"
alias trunc='cat /dev/null >'
alias watch='watch -n 1 '
alias v=$EDITOR
alias v.="$EDITOR ."
alias zgu='zgen update && sz'

