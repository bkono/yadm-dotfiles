HOME = os.getenv("HOME")
local util = require('util')
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local fn = vim.fn

g.mapleader = ","
g.maplocalleader = ","

-- Options{{{
opt.autoindent = true
opt.autowrite = true
opt.background = "dark"
opt.backspace = "indent,eol,start"
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.colorcolumn = "+1"
opt.cul = true
opt.cursorcolumn = true
opt.cursorline = true
opt.eol = false
opt.expandtab = true
opt.fillchars = "fold: "
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = 'v:lua.custom_fold_text()'
opt.hidden = true
opt.ignorecase = true
opt.incsearch = true
opt.lazyredraw = true
opt.list = true
opt.listchars = { nbsp = "␣", tab = "▸ ", trail = "·" }
opt.mouse = "a"
opt.errorbells = false
opt.scrolloff = 6
opt.shiftwidth = 2
-- opt.showbreak = "NONE"
opt.showbreak = "↳"
opt.showcmd = true
opt.showmode = true
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.textwidth = 120
opt.undofile = true
opt.undolevels = 1000

cmd("set wildcharm=<Tab>")
cmd("colorscheme lakeside")--}}}

-- Resize splits on windows size changes.
cmd [[
augroup ResizeSplits
    autocmd!
    autocmd VimResized * exe "normal! \<c-w>="
augroup END
]]

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', { pattern = '*', callback = function() vim.highlight.on_yank() end, group = group })

if fn.executable('rg') == 1 then
    opt.grepprg = "rg --vimgrep -H --no-heading --column --smart-case -P"                                          -- Set RipGrep as the default grep program (if it exists)
    opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- backup, undo{{{
if not util.exists(HOME .. '/.config/nvim/backup//') then
  util.mkdir(HOME .. '/.config/nvim/backup//')
end
if not util.exists(HOME .. '/.config/nvim/undo//') then
  util.mkdir(HOME .. '/.config/nvim/undo//')
end

opt.backupdir = HOME .. '/.config/nvim/backup//'
opt.undodir = HOME .. '/.config/nvim/undo//'--}}}

function _G.custom_fold_text()--{{{

    local line = vim.fn.getline(vim.v.foldstart)
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    local line_text = line:gsub('{+', '')
    local fill_count = vim.opt.textwidth._value - string.len(line_text) - string.len(line_count) - 4
    return " ⚡ " .. line_text .. ": " .. string.rep(" ", fill_count) .. "++ " .. line_count .. " lines"

end--}}}


-- vim: foldmethod=marker foldlevel=0 ts=2 sts=2 sw=2 et
