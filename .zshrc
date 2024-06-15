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
  # setup asdf isolation for rosetta instances
  export ASDF_DATA_DIR="$HOME/.config/rosetta/asdf"
  [[ ! -d "$ASDF_DATA_DIR" ]] && mkdir -p "$ASDF_DATA_DIR"

  path=(/usr/local/bin $path)
fi

[[ -d /opt/homebrew/bin && ("$arch" == "arm64") ]] && path=(/opt/homebrew/bin $path)
command -v brew &>/dev/null && eval "$(brew shellenv)"

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

  # evals - temporary tabling while getting parallel rosetta and silicon brew setups
  # zgenom eval --name direnv <<<"$(direnv hook zsh)"
  # zgenom eval --name starship <<<"$(starship init zsh)"

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
if command -v brew &>/dev/null; then
  [[ -f $(brew --prefix asdf)/libexec/asdf.sh ]] && source $(brew --prefix asdf)/libexec/asdf.sh
fi

[[ -d ~/.asdf/plugins/golang/ ]] && source ~/.asdf/plugins/golang/set-env.zsh
export ASDF_GOLANG_MOD_VERSION_ENABLED=true

command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v mise &>/dev/null && eval "$(mise activate zsh)"

[[ -e "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"