syntax on
let mapleader = "\<Space>"
set mouse=a
set number
set relativenumber
set modelines=0
set ruler
set encoding=utf-8

" Indenting and code formatting
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

set cursorline
:highlight Cursorline cterm=bold ctermbg=black

" Change Block Cursor when in Insert Mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" See the last N five lines below the cursor
set scrolloff=10

" Disable beep and flash
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" Config for dark themes
set background=dark
" Enable color themes
if !has('gui_running')
    set t_Co=256
endif
" Enable true colors support
set termguicolors
" Vim colorscheme
colorscheme desert

" Disable automatic line breaks
set nowrap

" Disable the creation of backup files and exchange files. (because Git)
set nobackup
set noswapfile
set nowritebackup

" Fuzzy Search
" Disable vi compatibility mode and limit search to your project
set nocompatible
" Search all subdirectories and recursively
set path+=**
" Shows multiple matches on one line
set wildmenu

" Automatically indent new lines
set autoindent

" Enable search highlighting
set hlsearch
" Enable incremental search highlighting
set incsearch
" Enable smartcase search sensitivity
set ignorecase
set smartcase

" Set clipboard between OS and Vim
set clipboard=unnamed

" Moving lines down and up using Ctrl+j and Ctrl+k
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv

" Navigate between open tabs
nnoremap <leader>h gT
nnoremap <leader>l gt

" Automatically save and restore the last editing position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Text width
set textwidth=80

" Automatically close (), {}, [], `` and ""
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

" Enable Markdown highlighting syntax
let g:markdown_fenced_languages = [
    \ "java",
    \ "javascript",
    \ "go",
    \ "ruby",
    \ "html",
    \ "css",
    \ "python",
    \ "c",
    \ "sh",
    \ "sql"
\ ]

" Background transparent
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE

" To prevent Vim from highlighting underscores as errors in specific file types
autocmd BufNewFile,BufRead,BufEnter *.md,*.rmd syn match markdownIgnore "\w\@<=\w\@="
