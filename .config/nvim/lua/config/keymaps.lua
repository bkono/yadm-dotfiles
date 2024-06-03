-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- CodeCompanion
-- map("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- map("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- map("n", "<Leader>a", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
-- map("v", "<Leader>a", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })

-- Expand `cc` into CodeCompanion in the command line
-- vim.cmd([[cab cc CodeCompanion]])

-- Buffers
map("n", "<C-x>", "<cmd>bd<cr>")

-- Git
vim.keymap.del("n", "<leader>ghr")

--
-- map("<leader><leader>", "<c-^>")
