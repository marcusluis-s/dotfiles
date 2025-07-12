local opts = { noremap = true, silent = true }
local map = vim.keymap.set

vim.g.mapleader = " "				-- Set leader key to space
vim.g.maplocalleader = " "			-- Set local leader key to space

-- Fast saving
-- map('n', '<C-s>', ':w<CR>', { desc = 'Save file (Ctrl-S)' })

-- Window navigation (using Ctrl + h/j/k/l)
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to down window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to up window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
map('n', '<Leader>wh', '<C-w><', { desc = 'Decrease window width' })
map('n', '<Leader>wl', '<C-w>>', { desc = 'Increase window width' })
map('n', '<Leader>wk', '<C-w>+', { desc = 'Increase window height' })
map('n', '<Leader>wj', '<C-w>-', { desc = 'Decrease window height' })
map('n', '<Leader>w=', '<C-w>=', { desc = 'Make windows equal size' })

-- New window splits
map('n', '<Leader>wv', ':vsplit<CR>', { desc = 'Split window vertically' })
map('n', '<Leader>ws', ':split<CR>', { desc = 'Split window horizontally' })

-- Buffer navigation
map('n', '[b', ':bprevious<CR>', { desc = 'Go to previous buffer' })
map('n', ']b', ':bnext<CR>', { desc = 'Go to next buffer' })
map('n', '<Leader>bc', ':bdelete<CR>', { desc = 'Close current buffer' })

-- Searching
map('n', '<Leader>h', ':noh<CR>', { desc = 'Clear search highlight' })

-- Move selected lines up/down (Visual mode)
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

-- Move current line up/down (Normal mode)
map('n', 'J', ':m .+1<CR>==', { desc = 'Move current line down' })
map('n', 'K', ':m .-2<CR>==', { desc = 'Move current line up' })

-- Delete single character without copying to register
map('n', 'x', '"_x', { desc = 'Delete character without yank' })

-- Global word replace (prompts for replacement, using common 's' for substitute)
map('n', '<Leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Global word replace (current word)' })

-- Tab Maps
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")   --open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>") --close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")     --go to next
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")     --go to pre
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>") --open current tab in new tab

