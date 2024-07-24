-- Keymap function alias
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move between split panes using Ctrl + hjkl
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Split window horizontally
keymap('n', '<leader>sh', ':split<CR>', opts)
-- Split window vertically
keymap('n', '<leader>sv', ':vsplit<CR>', opts)
