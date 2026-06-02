call plug#begin()

Plug 'vim-airline/vim-airline'
" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'spolu/dwm.vim'
" Plug 'jiangmiao/auto-pairs'
" Plug 'airblade/vim-rooter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
Plug 'ctrlpvim/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU'] }

" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-repeat'

" Plug 'maxmellon/vim-jsx-pretty', { 'for': ['jsx', 'tsx'] }
" Plug 'rhysd/vim-fixjson', { 'for': 'json' }

call plug#end()

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o    " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe     " Windows
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
            \ 'dir': 'node_modules\|database\|\v[\/]\.(git|hg|svn|undodir)$',
            \ 'file': '\v\.(exe|so|dll|o)$',
            \ }
let g:ctrlp_root_markers = ['pom.xml', '.idea', 'project.godot']
" Ignore .gitignore files
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
