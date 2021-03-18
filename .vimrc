"""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
Plug 'vim-ruby/vim-ruby'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'ntpeters/vim-better-whitespace'
Plug 'danilo-augusto/vim-afterglow'
Plug 'tpope/vim-rails'
Plug 'mattn/emmet-vim'
Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
Plug '907th/vim-auto-save'

call plug#end()
"""""""""""""""""""""""""""

colorscheme afterglow
let g:afterglow_inherit_background=1
let g:vim_json_syntax_conceal = 0

let g:deoplete#enable_at_startup = 1

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set folding style
set foldmethod=syntax
au BufRead * normal zR

" Set vim to directory of current file
set autochdir

" Do not make vim compatible with vi.
set nocompatible

" Do not create .swp files
set noswapfile

" Number the lines.
set number

" Show auto complete menus.
set wildmenu

" Make wildmenu behave like bash completion. Finding commands are so easy now.
set wildmode=list:longest

" Enable mouse pointing
set mouse=a

" ALWAYS spaces
set expandtab

" Fix backspace behavior
set backspace=indent,eol,start

" Use system clipboard
set clipboard=unnamed

" Keep Undo history on buffer change
set hidden
" Reload files after change on Disk
"set autoread
"au CursorHold * checktime

" Turn on syntax hightlighting.
set syntax=on
set nowrap
set tabstop=2
set shiftwidth=2
set nocindent

" Speed optimization
set ttyfast
set lazyredraw

" Theme
if exists('+termguicolors')
set termguicolors
endif

" Airline
set laststatus=2
let g:airline_theme='afterglow'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#ale#enabled=1

" Indent Guides
let g:indentLine_enabled=1
let g:indentLine_color_term=235
let g:indentLine_char='┆'

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

let g:ale_linters = {
      \   'ruby': ['rubocop'],
      \   'python': ['flake8', 'pylint'],
      \   'javascript': ['eslint'],
      \}
let g:ale_linters_explicit=1
let g:ale_sign_column_always=1
let g:ale_set_highlights=0

" vim-autosave
let g:auto_save=1
let g:auto_save_silent=1

""""""""""""""""""""""""""
" Custom bindings
""""""""""""""""""""""""""
let mapleader = ","

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Browse airline tabs
:nnoremap <C-p> :bnext<CR>
:nnoremap <C-o> :bprevious<CR>

" Map Control S for save
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S>  <C-O>:update<CR>

" Comment block
vnoremap <silent> <C-k> :Commentary<cr>

" Close current buffer
noremap <silent> <C-q> :Bclose!<CR>

" Select all
map <C-a> <esc>ggVG<CR>

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" Find files with fzf
nmap <leader>p :ProjectFiles<CR>


" Unmap arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

nmap // :BLines!<CR>
nmap ?? :Rg!<CR>

" remap ESC to exit terminal mode (breaks fzf popup)
tnoremap <Esc> <C-\><C-n>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Map moving between splits to normal vim movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Nerdtree
map <C-n> :NERDTreeToggle<CR>

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Set fold toggle to space in normal mode
nnoremap <space> za

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
