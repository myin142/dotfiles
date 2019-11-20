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
noremap <Leader>pb :CtrlPBuffer<cr>
noremap <Leader>pr :CtrlPMRU<cr>
noremap <Leader>c :Commentary<cr>
noremap <Leader>s :ToggleWorkspace<cr>
noremap <Leader>ff :NERDTreeFind<cr>
noremap <Leader>fl :Autoformat<cr>

" Tabs
noremap <A-t> :tabnew<cr>
noremap <A-w> :tabclose<cr>
noremap <A-h> :tabN<cr>
noremap <A-l> :tabn<cr>

" Buffer
noremap <Leader>bb :bprevious<cr>
noremap <Leader>bn :bnext<cr>
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
