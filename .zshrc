# vim: fdm=marker sw=2 ts=2 sts=2 tw=80 nofoldenable

# load zgenom
source "$HOME/.zgenom/zgenom.zsh"
export EDITOR='nvim'
export VEDITOR='code'

export ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)

# check for updates every 7 days
zgenom autoupdate --background

local arch=$(uname -m)

if [[ "$(uname -s)" == "Darwin" && -d /usr/local/bin && ("$arch" == "x86_64") ]]; then
  path=(/usr/local/bin $path)
fi

[[ -d /opt/homebrew/bin && ("$arch" == "arm64") ]] && path=(/opt/homebrew/bin $path)
[[ -d $HOME/.linuxbrew/bin ]] && path=($HOME/.linuxbrew/bin $path)
[[ -d $HOME/.linuxbrew ]] && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
[[ -d /home/linuxbrew/.linuxbrew/bin ]] && path=(/home/linuxbrew/.linuxbrew/bin $path)
[[ -d /home/linuxbrew/.linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ -d $HOME/.local/bin ]] && path=($HOME/.local/bin $path)
command -v brew &>/dev/null && eval "$($(brew --prefix)/bin/brew shellenv)"

if ! zgenom saved; then
  echo "Creating zgenom save state..."

  zgenom compdef

  # extensions
  zgenom load jandamm/zgenom-ext-eval
  zgenom load jandamm/zgenom-ext-release

  # omz
  zgenom ohmyzsh
  zgenom ohmyzsh plugins/git
  zgenom ohmyzsh plugins/ssh-agent
  zgenom ohmyzsh plugins/sudo
  zgenom ohmyzsh --completion plugins/docker-compose
  [[ "$(uname -s)" = Darwin ]] && zgenom ohmyzsh plugins/macos

  # qol
  zgenom load djui/alias-tips
  zgenom load hlissner/zsh-autopair
  zgenom load rupa/z

  # fzf
  zgenom load junegunn/fzf shell
  zgenom load urbainvaes/fzf-marks
  zgenom load wfxr/forgit

  zgenom load "$HOME/.config/zsh"

  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load zsh-users/zsh-completions

  [[ -x $(whence -cp upterm) ]] && zgenom eval --name upterm <<<"$(upterm completion zsh)"
  if command -v brew &>/dev/null && [[ -d $(brew --prefix)/share/zsh/site-functions ]]; then
    zgenom load --completion $(brew --prefix)/share/zsh/site-functions
  fi

  zgenom save

# Compile zsh files
  zgenom compile "$HOME/.zshrc"

  echo "...done"
fi

[ -d $HOME/.zgenom/bin ] && path=(~/.zgenom/bin $path)
[ -d ~/.local ] && path=(~/.local/bin $path)

command -v mise &>/dev/null && eval "$(mise activate zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

[[ -e "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
