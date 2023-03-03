-- local helpers{{{
HOME = os.getenv("HOME")
local util = require('util')
local vim = vim
local cmd = vim.cmd
local g = vim.g
local fn = vim.fn--}}}

-- packer bootstrap{{{
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end--}}}

function mini_setup()--{{{
  require('mini.bufremove').setup {}
  require('mini.comment').setup {}
  g.minicompletion_disable=true
  require('mini.cursorword').setup {}
  g.minidoc_disable=true
  g.minifuzzy_disable=true
  require('mini.indentscope').setup {}
  -- require('mini.jump').setup {}
  -- require('mini.jump2d').setup {}
  cmd([[highlight MiniJump2dSpot gui=undercurl guisp=red]])

  require('mini.misc').setup {}
  -- require('mini.pairs').setup {}

  local sd = HOME .. '/.config/nvim/sessions//'
  if not util.exists(sd) then
    util.mkdir(sd)
  end
  require('mini.sessions').setup {
    autoread = false,
    autowrite = true,
    directory = sd,
  }

  require('mini.starter').setup {}  -- make this streamlined for my use
  require('mini.statusline').setup {}  -- come set this up more like airline
  require('mini.surround').setup {}  -- come back and set up as tim pope surround if new mappings are frictiony
  require('mini.tabline').setup {}  -- come back and set up as tim pope surround if new mappings are frictiony
  require('mini.trailspace').setup {}  -- come back and set up as tim pope surround if new mappings are frictiony

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    callback = function()
      local exclude = {go=true, python=true, ruby=true, elixir=true}
      if exclude[vim.bo.filetype] then
        return
      end
      MiniTrailspace.trim()
    end,
  })
end--}}}

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- themes{{{
  use 'mhartington/oceanic-next'
  --}}}

  -- langs{{{
  use 'elixir-editors/vim-elixir'
  --}}}

  -- completion & lsp stuff {{{
  use {'neoclide/coc.nvim', branch = 'release'}

  use {'github/copilot.vim'}

  -- use {
  --   'Exafunction/codeium.vim',
  --   config = function ()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set('i', '<C-g>', function ()
  --       return vim.fn['codeium#Accept']()
  --     end, { expr = true })
  --   end
  -- }
  -- }}}

  -- lsp stuff{{{
  -- use {
  --   "williamboman/nvim-lsp-installer",
  --   "neovim/nvim-lspconfig",
  -- }
  -- use { 'ms-jpq/coq_nvim', run = 'python3 -m coq deps' }
  -- use("ms-jpq/coq.artifacts")
  -- use("ms-jpq/coq.thirdparty")
  -- g.coq_settings = { auto_start = 'shut-up' }--}}}

  use { 'ibhagwan/fzf-lua',--{{{
    -- optional for icon support
    requires = { 'kyazdani42/nvim-web-devicons' }
  }--}}}

  -- general
  use { 'lewis6991/gitsigns.nvim',--{{{
    config = function()
      require('gitsigns').setup()
    end
  }--}}}

  use 'kdheepak/lazygit.nvim'
  use 'airblade/vim-rooter'

  -- 'echasnovski/mini.nvim' setup{{{
  use {
    'echasnovski/mini.nvim',
    config = function() mini_setup() end
  }--}}}
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {map_cr = false} end
  }

  use 'ggandor/leap.nvim'

  -- Automatically set up your configuration after cloning packer.nvim{{{
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end--}}}

  -- Automatic compile of packer.lua on save{{{
  vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
  ]])--}}}
end)


-- vim: foldmethod=marker foldlevel=0 ts=2 sts=2 sw=2 et
