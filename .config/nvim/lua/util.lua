local vim = vim or {}
local api = vim.api
local fn = vim.fn

local util = {}

-- thanks https://github.com/alexanderjeurissen/dotfiles/blob/main/config/nvim/lua/util.lua

function util.noop() --[[ do nothing ]] end

-- Show confirm dialog before executing predicate
function util.confirm(options, msg)
  local defaults = { Yes = util.noop, No = util.noop }
  msg = msg or 'Are you sure ?'
  options = options or defaults

  local option_tbl = {}
  local callback_tbl = {}

  for option, callback in pairs(options) do
    table.insert(option_tbl, '&'..option)
    table.insert(callback_tbl, callback)
  end

  local option_str = table.concat(option_tbl, '\n')

  local choice = vim.fn.confirm(msg, option_str)
  local choice_func = callback_tbl[choice]

  if choice and choice_func and type(choice_func) == 'function' then
    choice_func()
  end
end

-- Check if a file or directory exists in this path
function util.exists(path)
  return io.open(path, "r") and true or false
end

-- create directory if it doesn't exist yet
function util.mkdir(path)
  if util.exists(path) then return false end
  return os.execute('mkdir -p ' .. path) and true or false
end

function util.getPath(str)
  local s = str:gsub("%-","")
  return s:match("(.*[/\\])")
end

local cmd = vim.cmd
local opts = { noremap = true, silent = true }

function util.map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

function util.nmap(shortcut, command)
  util.map('n', shortcut, command)
end

function util.imap(shortcut, command)
  util.map('i', shortcut, command)
end

function util.vmap(shortcut, command)
  util.map('v', shortcut, command)
end

function util.cmap(shortcut, command)
  util.map('c', shortcut, command)
end

return util
