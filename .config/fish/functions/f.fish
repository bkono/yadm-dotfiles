function f -d "Fuzzy-find and open a file in current directory"
  set file (fzf --height 40% --info inline --border --reverse --preview 'bat {}')
  if test -n "$file"
    nvim $file
  end
end
