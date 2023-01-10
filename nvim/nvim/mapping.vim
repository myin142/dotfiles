function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command ToggleGStatus :call ToggleGStatus()

""""""""""""""""""""""
" Keyboard Shortcuts "
""""""""""""""""""""""
vnoremap <C-c> "*y
noremap <C-s> :w<cr>
noremap <space> :noh<cr>

noremap <C-p> :CtrlP<cr>
noremap <C-/> :Commentary<cr>
noremap <Leader>pb :CtrlPBuffer<cr>
noremap <Leader>pr :CtrlPMRU<cr>
noremap <Leader>s :ToggleWorkspace<cr>
noremap <Leader>ff :NERDTreeFind<cr>
noremap <Leader>fl :Autoformat<cr>

" Tabs
noremap <Leader>tt :tabnew<cr>
noremap <Leader>tx :tabclose<cr>
noremap <Leader>th :tabN<cr>
noremap <Leader>tl :tabn<cr>

" Windows
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l

noremap <A-H> <C-w>H
noremap <A-J> <C-w>J
noremap <A-K> <C-w>K
noremap <A-L> <C-w>L

" Buffer
noremap <Leader>bh :bprevious<cr>
noremap <Leader>bl :bnext<cr>
noremap <Leader>bx :bp <bar> bd #<cr>

" Views
noremap <A-1> :NERDTreeToggle<cr>
noremap <A-2> :ToggleGStatus<cr>
noremap <A-3> :TagbarToggle<cr>

" Git
noremap <Leader>gz :GitGutterUndoHunk<cr>
noremap <Leader>gp :GitGutterPreviewHunk<cr>
noremap <Leader>gs :GitGutterStageHunk<cr>
noremap <Leader>gc :Gcommit<cr>
noremap <Leader>gd :Git diff --staged<cr>
