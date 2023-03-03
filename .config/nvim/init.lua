HOME = os.getenv("HOME")
local vim = vim
local g = vim.g
local opt = vim.opt

-- line-numbers must be declared before dashboard
-- init because otherwise dashboard shows line numbers
opt.nu = true
opt.rnu = true
opt.numberwidth = 3

g.python3_host_prog = HOME .. "/.asdf/shims/python3"

require "plugins"
require "settings"
require "keymaps"
