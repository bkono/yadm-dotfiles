-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
HOME = os.getenv("HOME")
vim.g.mapleader = ","
vim.g.python3_host_prog = HOME .. "/.asdf/shims/python3"
