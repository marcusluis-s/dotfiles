" ===========================
" BASICS
" ===========================
syntax on                     " Enable syntax highlighting
set encoding=utf-8            " Set file encoding
let mapleader = "\<Space>"    " Set leader key to <Space>
set nocompatible              " Disable vi compatibility mode

" ===========================
" APPEARANCE
" ===========================

set number                    " Show absolute line numbers
set relativenumber            " Show relative line numbers
set cursorline                " Highlight the current line
:highlight Cursorline cterm=bold ctermbg=black
set ruler                     " Show cursor position in the status line
set mouse=a                   " Enable mouse support

" Theme and Colors
set background=dark           " Set background to dark
set termguicolors             " Enable true color support
if !has('gui_running')
    set t_Co=256              " Use 256 colors if GUI is not running
endif
let g:tokyonight_style = 'night'                " Theme style (available: night, storm)
let g:tokyonight_enable_italic = 1
colorscheme tokyonight                          " Set the colorscheme to tokyonight

" Enable statusline
set laststatus=2
" Dynamic statusline definition
set statusline=
set statusline+=%#User2#                 " Highlight group for mode
set statusline+=%{StatuslineMode()}      " Current mode
set statusline+=%#User1#                 " Default text highlight
set statusline+=\ %{b:gitbranch}           " Git branch info
set statusline+=                     " Escaped <<
set statusline+=%t                     " Short filename
set statusline+=                     " Escaped >>
set statusline+=%=                       " Right alignment
set statusline+=%#User3#                 " Highlight for flags
set statusline+=%h%m%r                   " File flags (help, modified, readonly)
set statusline+=\                        " Escaped
set statusline+=%l/%L\                   " Line count
set statusline+=%y                       " File type

" Dynamic highlight group updates
function! SetStatuslineColors()
  " Get colors from the current theme
  let l:status_fg = synIDattr(synIDtrans(hlID('StatusLine')), 'fg#')
  let l:status_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'bg#')
  let l:noncurrent_fg = synIDattr(synIDtrans(hlID('StatusLineNC')), 'fg#')
  let l:noncurrent_bg = synIDattr(synIDtrans(hlID('StatusLineNC')), 'bg#')

  " Define custom highlight groups based on theme colors
  exec 'hi User1 guifg=' . l:status_fg . ' guibg=' . l:status_bg
  " Inverted colors for mode
  exec 'hi User2 guifg=' . l:status_bg . ' guibg=' . l:status_fg
  exec 'hi User3 guifg=' . l:noncurrent_fg . ' guibg=' . l:noncurrent_bg
endfunction

" Automatically update colors on color scheme change
autocmd ColorScheme * call SetStatuslineColors()
call SetStatuslineColors()

" Statusline mode display function
function! StatuslineMode()
    let l:mode = mode()
    if l:mode ==# "n"
        return "NORMAL"
    elseif l:mode ==# "v"
        return "VISUAL"
    elseif l:mode ==# "i"
        return "INSERT"
    elseif l:mode ==# "R"
        return "REPLACE"
    endif
    return ""
endfunction

" Git branch extraction function
function! StatuslineGitBranch()
  let b:gitbranch = ""
  if &modifiable
    try
      lcd %:p:h
    catch
      return
    endtry
    let l:gitrevparse = system("git rev-parse --abbrev-ref HEAD")
    lcd -
    if l:gitrevparse !~ "fatal: not a git repository"
      let b:gitbranch = "  (".substitute(l:gitrevparse, '\n', '', 'g').") "
    endif
  endif
endfunction

" Automatically update git branch info
augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" Display special characters
set list                      " Display tabs, trailing spaces, and other special characters
set listchars=tab:>-,trail:~,extends:>,precedes:<,nbsp:+
set showbreak=↳               " Show ↳ at the end of the buffer

" ===========================
" INDENTATION AND FORMATTING
" ===========================
set tabstop=4                 " Number of spaces per tab
set shiftwidth=4              " Spaces for each indentation
set softtabstop=4             " Spaces for Tab in insert mode
set expandtab                 " Convert tabs to spaces
set noshiftround              " Avoid auto-aligning shifts to `shiftwidth`
set autoindent                " Automatically indent new lines
set nowrap                    " Disable automatic line wrapping
set textwidth=80              " Set maximum text width to 80 characters

" ===========================
" SEARCH
" ===========================
set hlsearch                  " Highlight search matches
set incsearch                 " Enable incremental search
set ignorecase                " Case-insensitive search
set smartcase                 " Case-sensitive if uppercase in query
set wildmenu                  " Show a wild menu for command completions
set path+=**                  " Allow searching subdirectories recursively

" ===========================
" BACKUPS AND FILE HANDLING
" ===========================
set nobackup                  " Disable backup files
set noswapfile                " Disable swap files
set nowritebackup             " Disable write-backup files

" Automatically save and restore the last editing position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" ===========================
" MAPPINGS AND SHORTCUTS
" ===========================
" Moving lines up and down with Ctrl+j/k
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv

" Navigate between open tabs
nnoremap <leader>h gT
nnoremap <leader>l gt

" Automatically close pairs of (), {}, [], "", and ``
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

" ===========================
" MARKDOWN SUPPORT
" ===========================
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

" Prevent underscores from being highlighted as errors in Markdown
autocmd BufNewFile,BufRead,BufEnter *.md,*.rmd syn match markdownIgnore "\w\@<=\w\@="

" ===========================
" SPLITS AND NAVIGATION
" ===========================
set splitbelow                " Open new horizontal splits below
set splitright                " Open new vertical splits to the right

" ===========================
" MISCELLANEOUS
" ===========================
" Change block cursor in Insert mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Scroll context (keep lines visible around the cursor)
set scrolloff=10

" Disable system beeps and flashes
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" ===========================
" LANGUAGE-SPECIFIC SETTINGS
" ===========================

" General: Automatically detect the file type and load appropriate settings
filetype plugin indent on

" Java: Adjust indentation and enable syntax highlighting
autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
autocmd FileType java setlocal makeprg=javac\ % " Set Java compiler

" JavaScript and TypeScript: Use 2 spaces for indentation
" autocmd FileType javascript,typescript setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd FileType javascript,typescript setlocal formatoptions-=cro " Disable auto-comment continuation

" React (JSX/TSX): Treat as JavaScript/TypeScript
autocmd BufRead,BufNewFile *.jsx,*.tsx set filetype=javascriptreact

" C: Use 4 spaces for indentation and set a common style
autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
autocmd FileType c setlocal formatoptions-=cro " Disable auto-comment continuation

" HTML and CSS: Use 2 spaces for indentation
" autocmd FileType html,css setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2

" Markdown: Enable spell checking and soft wrapping
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType markdown setlocal wrap linebreak
" autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd FileType markdown setlocal formatoptions+=tq " Auto-wrap text

" ===========================
" ADDITIONAL IMPROVEMENTS FOR LANGUAGE-SPECIFIC SETTINGS
" ===========================

" Automatically close HTML and JSX tags
autocmd FileType html,xml,javascriptreact inoremap </ </<C-x><C-o>

" Enhanced syntax highlighting for TypeScript
let g:typescript_highlight_functions = 1
let g:typescript_highlight_methods = 1
let g:typescript_highlight_operators = 1
let g:typescript_highlight_class_members = 1
let g:typescript_highlight_interfaces = 1

" Enable linting (if ALE or other linting plugin is installed)
let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint'],
    \ 'java': ['javac'],
    \ 'c': ['gcc'],
    \ 'html': ['tidy'],
    \ 'css': ['stylelint'],
    \ }

" Enable Prettier for JavaScript/TypeScript formatting
autocmd FileType javascript,typescript nnoremap <leader>f :!prettier --write %<CR>

" Add comment support for React and JSX files
autocmd FileType javascriptreact setlocal commentstring=<!--\ %s\ -->

" ===========================
" CODE FOLDING
" ===========================

" Enable folding and set default method - `za`, `zc`, `zo`
set foldenable          " Ativar o folding
set foldmethod=indent   " Usar indentação para determinar os blocos de fold
set foldlevel=99        " Abre todos os folds por padrão (99 é praticamente "tudo aberto")
set foldnestmax=3       " Limitar o número máximo de níveis de fold visíveis
set foldminlines=1      " Mínimo de linhas para ativar um fold

" ===========================
" KEYBINDINGS
" ===========================

" It's empty here
