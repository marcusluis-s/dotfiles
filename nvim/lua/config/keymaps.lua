-- Keymap function alias
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move between split panes using Ctrl + hjkl
-- keymap('n', '<C-h>', '<C-w>h', opts)
-- keymap('n', '<C-j>', '<C-w>j', opts)
-- keymap('n', '<C-k>', '<C-w>k', opts)
-- keymap('n', '<C-l>', '<C-w>l', opts)

-- Split window horizontally
keymap('n', '<leader>sh', ':split<CR>', opts)
-- Split window vertically
keymap('n', '<leader>sv', ':vsplit<CR>', opts)

-- Move lines up and down using Ctrl+k and Ctrl+j
-- Normal mode mappings
keymap('n', '<C-j>', ':m .+1<CR>==', opts)
keymap('n', '<C-k>', ':m .-2<CR>==', opts)

-- Insert mode mappings
keymap('i', '<C-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('i', '<C-k>', '<Esc>:m .-2<CR>==gi', opts)

-- Visual mode mappings
keymap('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
keymap('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)

-- Navigate between open tabs
keymap('n', '<leader>h', 'gT', opts)
keymap('n', '<leader>l', 'gt', opts)
