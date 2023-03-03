function fb -d "Fuzzy-find and checkout a branch"
  git rev-parse HEAD > /dev/null 2>&1 || return
  git branch --all --sort=-committerdate | grep -v HEAD | string trim | fzf -d 15 --reverse --preview='git show --color=always --stat --patch {1}' | read -l result
  if test -n "$result"
    if string match "remotes/*" "$result"
      git checkout -t "$result"
    else
      git checkout "$result"
    end
  end
end
