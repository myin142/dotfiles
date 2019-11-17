set mouse=a
set number
set relativenumber
set noswapfile
set nowrap
set updatetime=500

" Fold
set foldmethod=syntax
set foldnestmax=2
set foldlevel=2

" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Show invisible characters
set list
set listchars=tab:\|\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

set ignorecase              " case insensitive searching
set smartcase               " case-sensitive if expresson contains a capital letter

" Auto Commands
autocmd BufEnter * silent! lcd %:p:h            " Change working directory to current file

""""""""""""""""""""""
" Keyboard Shortcuts "
""""""""""""""""""""""
vnoremap <C-c> "+y
noremap <C-s> :w<cr>
noremap <space> :noh<cr>

" Tabs
noremap <C-t> :tabnew<cr>
noremap <C-w> :tabclose<cr>
noremap <C-h> :tabN<cr>
noremap <C-l> :tabn<cr>

noremap <Leader>c :Commentary<cr>
noremap <C-p> :CtrlP<cr>

" Git
noremap <Leader>gz :GitGutterUndoHunk<cr>
noremap <Leader>ga :Git add .<cr><cr>
noremap <Leader>gp :Git add -p .<cr>
noremap <Leader>gs :Gstatus<cr>
noremap <Leader>gc :Gcommit<cr>
noremap <Leader>gd :Git diff --staged<cr>

"""""""""""
" Plugins "
"""""""""""
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'spolu/dwm.vim'
Plug 'janko/vim-test' " Karma tests currently not working
Plug 'zgpio/tree.nvim' " Currently not working
call plug#end()

" Plugin Settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:ctrlp_custom_ignore = {
\ 'dir': 'node_modules\|database\|\v[\/]\.(git|hg|svn)$',
\ 'file': '\v\.(exe|so|dll|o)$',
\ }
