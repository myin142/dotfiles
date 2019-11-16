set mouse=a
set number
set relativenumber
set noswapfile

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
noremap <Leader>z :GitGutterUndoHunk<cr>

"""""""""""
" Plugins "
"""""""""""
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
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

" GitGutter update time
set updatetime=500
