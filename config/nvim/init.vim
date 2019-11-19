set autoread
set hidden
set mouse=a
set number
set relativenumber
set nobackup
set nowritebackup
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

" autocmd BufWrite * :Autoformat                  " Autoformat on save

source $HOME/.config/nvim/coc-config.vim
source $HOME/.config/nvim/mapping.vim
source $HOME/.config/nvim/plugin.vim
