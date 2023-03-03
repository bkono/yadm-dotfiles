set -xg EDITOR nvim
set -xg VISUAL nvim
set -xg GOPATH $HOME
set -xg GPG_TTY (tty) # fixes gpg in git
set -xg ERL_AFLAGS "-kernel shell_history enabled" # iex shell history

set -xg CC "/opt/hombrew/opt/llvm/bin/clang"
set -xg CXX "/opt/hombrew/opt/llvm/bin/clang++"
set -xg LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -xg CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

fish_add_path /usr/local/bin

if test -d /opt/homebrew/bin
  fish_add_path /opt/homebrew/bin
end

if test -d /opt/homebrew/opt/llvm/bin
  fish_add_path /opt/homebrew/opt/llvm/bin
end

if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
  fish_add_path /Applications/Postgres.app/Contents/Versions/latest/bin
end

fish_add_path ~/bin

# one-off abbrs
abbr e "$EDITOR"
alias l 'gls -lhAF --color=auto --group-directories-first'
abbr md 'mkdir -p'
abbr irb "irb -r 'irb/completion'"
abbr daa "direnv allow"
abbr rg "rg -L"
abbr rmrf "rm -rf"
abbr tns 'tmux new-session -ADd -s'
abbr uuid "uuidgen | string lower | tr -d '\n' | pbcopy && pbpaste && echo"

# git
abbr gs "git status -sb"
abbr gdm git diff (__git.default_branch)
abbr gcob "git checkout -b"

 # vim
abbr v   "$EDITOR"
abbr v.  "$EDITOR ."

# fzf
set fzf_dir_opts --bind "ctrl-v:execute(nvim {} &> /dev/tty)"
set fzf_fd_opts --hidden --exclude=.git
fzf_configure_bindings --directory=\ct
