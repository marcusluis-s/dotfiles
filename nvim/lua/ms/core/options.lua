vim.cmd("let g:netrw_banner = 0")

-- vim.g.loaded_netrw = 1				-- Disable Netrw
-- vim.g.loaded_netrwPlugin = 1		-- Disable Netrw

-- vim.opt.guicursor = ""				-- Change cursor to block intead of line
vim.opt.guicursor = "n-v-c-sm:block,i:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250"
vim.opt.number = true				-- Show line numbers
vim.opt.relativenumber = true			-- Show relative line numbers

vim.opt.backup = false				-- Do not create backup files
vim.opt.writebackup = false			-- Do not create backup files when overwriting
vim.opt.swapfile = false			-- Do not create swap files

-- vim.opt.undofile = true			-- Enable persistent undo
-- vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Set undo directory

vim.opt.hlsearch = true				-- Highlight all matches for the current seatch pattern
vim.opt.incsearch = true			-- Show partial matches while typing seatch pattern
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = "unnamedplus"		-- Allows NeoVim to use the system clipboard

vim.opt.scrolloff = 8				-- Lines of context arount the cursor when scrolling
vim.opt.sidescrolloff = 8			-- Columns of context arount the cursor when horizontally scrolling

vim.opt.expandtab = true			-- Use spaces instead of tabs
vim.opt.tabstop = 4					-- Number of spaces a tab count for
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4				-- Number of spaces to use for each step (auto)indent

vim.opt.autoindent = true			-- Copy indent from current line when starting a new line
vim.opt.smartindent = true			-- Smart auto-indenting for C-like languages

vim.opt.wrap = false				-- Do not wrap long lines

vim.opt.mouse = "a"					-- Enable mouse support in all modes

vim.opt.termguicolors = true		-- Enable true colors support
vim.opt.background = "dark"

vim.opt.showmode = false			-- Don't show the current mode (e.g., -- INSERT --) as it's often redundant with statusline plugin

vim.opt.signcolumn = "yes"			-- Always show the sign column, even if empty

vim.opt.updatetime = 300			-- Faster completion (ms to wait for the file to be written to disk)

vim.opt.timeoutlen = 500			-- Time in ms to wait for a mapped sequence to complete

vim.opt.completeopt = "menu,menuone,noselect"		-- Autocomplete options
vim.opt.pumheight = 10				-- Maximum number of items to show in the popup menu

vim.opt.backspace = {"start", "eol", "indent"}

vim.opt.confirm = true				-- Ask for confirmation when closing unsaved buffers

vim.opt.splitbelow = true			-- New windows split below the current one
vim.opt.splitright = true			-- New windows split to the right of the current one

vim.opt.diffopt:append("vertical")	-- Show diffs vertical splits by default

-- vim.opt.cmdheight = 1               -- To make the status line and command line area take up less vertical space

