# Defines config for a kono-style zshell

# Ensure languages are set
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ "$TERM" == xterm ]]; then
  export TERM=xterm-256color
fi

CUR=${0:a:h}
source "$CUR/functions.zsh"
source "$CUR/aliases.zsh"
# source "$CUR/jump.zsh"

# awesome cd movements from zshkit
setopt AUTOCD
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt cdablevars

# Save a metric ton of history
HISTSIZE=100000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
unsetopt HIST_BEEP

# setopt interactive_comments extended_glob complete_aliases always_to_end complete_in_word

# Enabled true color support for terminals
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# show contents after cd'ing
# chpwd() {
#   ls -AlhF --color=auto --group-directories-first
# }

# Expand aliases inline - see http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
    zle expand-word
  fi
  zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches

bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
# bindkey '^[[1;5C' forward-word     # [Ctrl-RightArrow] - move forward one word
# bindkey '^[[1;5D' backward-word    # [Ctrl-LeftArrow]  - move backward one word

# up and down for history search
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
