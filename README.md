# yadm-dotfiles

This is a seriously streamlined version of bkono's dotfiles. An aggregation of techniques and workflow refinements built
over more than 15 years of iteration.

## Installation

You are welcome to pick and choose however you like. `.config` contains lots of goodies, like my fish and zsh setup, a streamlined neovim configuration, and an alacritty w/ tmux config that gives iterm like keybindings.

In case you couldn't gather from the name, these are meant to be used with [yadm](https://yadm.io) / in a bare git repo
model.

If you are comfortable blowing away what you currently have (or its all symlinks to a separate repo for easy restore),
there is a [setup-mac](https://raw.githubusercontent.com/bkono/yadm-dotfiles/main/.local/bin/setup-mac) script that is
meant to go from totally fresh to functional.

Easiest way to use it is curl'ing ala brew.sh install steps:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bkono/yadm-dotfiles/main/.local/bin/setup-mac)"
```

It'll prompt for whether the machine is a Work (minimal brewfile) or Personal (more apps and libs in the Brewfile), and
then proceed to setup yadm, checkout the files, and run the [bootstrap](https://github.com/bkono/yadm-dotfiles/blob/main/.config/yadm/bootstrap). Highly recommend reviewing both the setup and bootstrap scripts to see what you're getting yourself into before using it.

