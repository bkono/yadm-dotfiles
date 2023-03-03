local util = require('util')
local vim = vim
local cmd = vim.cmd
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local nmap = util.nmap
local imap = util.imap
local vmap = util.vmap
local cmap = util.cmap

nmap("<Leader>n", ":nohlsearch<cr>")

-- Switch between the last two files
nmap("<leader><leader>", "<c-^>")

-- Visual shifting (does not exit Visual mode), allows repeats
vmap("<", "<gv")
vmap(">", ">gv")
vmap(".", ":normal .<CR>")

-- Force save when I forget to open it with sudo
cmap("w!!", "w !sudo tee > /dev/null %")

-- Easy navigation
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')
nmap('tn', ':tabnew<CR>')
nmap('tk', ':tabnext<CR>')
nmap('tj', ':tabprev<CR>')
nmap('to', ':tabo<CR>')
nmap('<C-S>', ':%s/')
nmap("<leader>t", ":sp<CR> :term<CR> :resize 20N<CR> i")
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {noremap = true, silent = true})
nmap("<C-x>", "<C-w>c")

-- Easy splits
nmap('vv', '<C-w>v')
-- nmap('ss', '<C-w>s')
nmap("<Leader>e", ":e <C-R>=expand(\"%:p:h\") . '/'<CR>")
nmap("<Leader>s", ":split <C-R>=expand(\"%:p:h\") . '/'<CR>")
nmap("<Leader>v", ":vnew <C-R>=expand(\"%:p:h\") . '/'<CR>")

-- FZF
nmap('<C-P>', "<cmd>lua require('fzf-lua').files()<CR>")
nmap('<Leader>fb', "<cmd>lua require('fzf-lua').buffers()<CR>")
nmap('<Leader>fh', "<cmd>lua require('fzf-lua').oldfiles()<CR>")
nmap('<Leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>")

-- Git stuff
nmap('<Leader>gg', ':LazyGit<CR>')

-- Mini
nmap('<leader>f', "<cmd>lua MiniJump2d.start()<CR>")
nmap('<Leader>msw', ":lua MiniSessions.write()<left>")

-- Coc
function _G.check_back_space()
    local col = fn.col('.') - 1
    if col == 0 or fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', { expr = true })
map("i", "<S-TAB>", 'pumvisible() ? coc#pum#prev(1) : "<C-H>"', { expr = true })
map("i", '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"', {expr = true, silent = true, noremap = true})
map("i", "<C-SPACE>", 'coc#refresh()', { expr = true })
map("i", '<C-F>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<Right>"', { expr = true, silent = true, nowait = true })
map("i", '<C-B>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<Left>"', { expr = true, silent = true, nowait = true })
-- -- map("i", '<CR>',  'v:lua.MUtils.completion_confirm()', {expr = true, noremap = true})
nmap( "K", ":call CocActionAsync('doHover')<CR>")
nmap( '[c', '<Plug>(coc-diagnostic-prev)')
nmap( ']c', '<Plug>(coc-diagnostic-next)')
nmap( 'gb', '<Plug>(coc-cursors-word)')
nmap( 'gd', '<Plug>(coc-definition)')
nmap( 'gy', '<Plug>(coc-type-definition)')
nmap( 'gi', '<Plug>(coc-implementation)')
nmap( 'gr', '<Plug>(coc-references)')
nmap('<leader>.', "<Plug>(coc-codeaction)")
nmap('<leader>qf', '<Plug>(coc-fix-current)')
nmap('<leader>rn', '<plug>(coc-rename)')

-- map("n", "0", "^", opts)
-- map("n", "^", "0", opts)

function rename_file()
  local fname = vim.api.nvim_buf_get_name(0)
  local new_name = vim.fn.input('New file name: ', fname)

  if new_name and #new_name > 0 and new_name ~= fname then
    util.confirm({
      Yes = function()
        vim.fn.rename(fname, new_name)
        vim.cmd('edit ' .. new_name)
        vim.cmd('w! ' .. new_name)
        vim.cmd('redraw!')
      end,
      No = util.noop
    })
  end
end
nmap('<Leader>rnf', "<cmd>lua rename_file()<CR>")

-- leap config
nmap('ss', '<Plug>(leap-forward-to)')
nmap('S', ' <Plug>(leap-backward-to)')
