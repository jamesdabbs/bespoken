" This is standard pathogen and Vim setup
set nocompatible
call pathogen#infect()
syntax on
filetype plugin indent on

" Keep temp files in a central location
set backupdir=~/.vim/tmp,/var/tmp,/tmp
set directory=~/.vim/tmp,/var/tmp,/tmp

" Use width-2 soft tabs
set expandtab
set shiftwidth=2
set softtabstop=2
set smartindent

" Better search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Shell-style tab completion
set wildmenu
set wildmode=list:longest

" CtrlP .ignore
set wildignore+=*/node_modules/*,*.so,*.o

" Use 256 color schemes
set t_Co=256
try
  colorscheme tir_black
catch
  colorscheme pablo
endtry

" Allow backspacing over auto-indents
set backspace=indent,eol,start

" Trailing whitespace tools
highlight ExtraWhitespace ctermbg=237 guibg=237
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" GitGutter
highlight clear SignColumn
let g:gitgutter_sign_column_always = 1

" Tweaks
let mapleader=","
nnoremap <leader><leader> <c-^>

map <leader>R :so $MYVIMRC<cr>
map <leader>b :NERDTreeToggle<cr>

" Slightly faster paging
nnoremap <c-e> 5<c-e>
nnoremap <c-y> 5<c-y>

" Window navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
inoremap <c-j> <esc><c-w>j
inoremap <c-k> <esc><c-w>k
inoremap <c-h> <esc><c-w>h
inoremap <c-l> <esc><c-w>l

" Overtone helpers
map <leader>x :Eval<cr>
map <leader>q :Eval (stop)<cr>

" Spec helpers
function! SpecFile()
  !spring rspec %
endfunction
function! SpecFiles()
  !spring rspec
endfunction
nnoremap <leader>s :call SpecFile()<CR>
nnoremap <leader>S :call SpecFiles()<CR>

