-- Mappings.
-- 'silent = true' does not echo the mapping in the commmand line.
local default_opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Mappings not dependent in plugins.
vim.keymap.set('n', "<Space>", "<NOP>", default_opts)
vim.keymap.set('i', "jk", "<Esc>", default_opts)
vim.keymap.set('n', "<leader>ev", ":e $MYVIMRC<cr>", default_opts)
vim.keymap.set('v', "<leader>c", '"+y', default_opts)
vim.keymap.set('n', "<S-J><S-J>", "<C-W><C-W>", default_opts)
vim.keymap.set('n', "<C-H>", "<C-W><C-H>", default_opts)
vim.keymap.set('n', "<C-J>", "<C-W><C-J>", default_opts)
vim.keymap.set('n', "<C-K>", "<C-W><C-K>", default_opts)
vim.keymap.set('n', "<C-L>", "<C-W><C-L>", default_opts)
vim.keymap.set('i', "<C-Space>", "<C-X><C-O>", default_opts)
vim.keymap.set('n', "<leader>q", ":silent sus<cr>", default_opts)
vim.keymap.set('n', "<leader>d", ":lua vim.diagnostic.open_float()<cr>", default_opts)
