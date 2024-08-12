vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

-- Set default encoding
vim.opt.encoding = "UTF-8"

-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Set tab width to 4 spaces
vim.opt.tabstop = 4
-- Set the number of spaces to use for each step of (auto) indent
vim.opt.shiftwidth = 4

-- Disable line wrapping
vim.opt.wrap = false

-- Enable mouse support
vim.opt.mouse = "a"
-- Disable right click pop-up menu
vim.opt.mousemodel = "extend"

-- Open new windows at the bottom and new vertical w. at the right side
vim.opt.splitbelow = true
vim.opt.splitright = true

-- System clipboard for copy and paste
vim.opt.clipboard = "unnamedplus"

-- Sets the number of line to keep visible above and below
vim.opt.scrolloff = 10

-- Allow cursor movement to columns beyond the end of a line
vim.opt.virtualedit = "block"

-- Split the window to show all the changes in real time
vim.opt.inccommand = "split"

-- Controls whether searches are case-sensitive or case-insensitive
vim.opt.ignorecase = true
-- This makes searches with a single capital letter to be case sensitive
vim.opt.smartcase = true

-- Enable 24-bit RGB colors
vim.opt.termguicolors = true

-- Set the number of columns used for line numbers
vim.opt.numberwidth = 1

-- Set the signcolumn width
vim.opt.signcolumn = "yes:1"

-- This sets the folding method
vim.opt.foldmethod = "manual"

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "noinsert", "noselect" }
-- Avoid showing message extra message when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Disable swapfiles
vim.opt.swapfile = false

-- Raise a dialog for certain operations that would normally fail (e.g. unsaved buffer)
vim.opt.confirm = true

-- Set up the default shell in neovim
vim.opt.shell = vim.fn.exepath "zsh"

-- Define how whispaces characters are visually represented in the editor
vim.opt.list = false
vim.opt.listchars = {
    eol = '↵',
    trail = '~',
    tab = '>-',
    nbsp = '␣'
}
