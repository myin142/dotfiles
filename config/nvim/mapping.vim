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
noremap <Leader>s :ToggleWorkspace<cr>

" Tabs
noremap <A-t> :tabnew<cr>
noremap <A-w> :tabclose<cr>
noremap <A-h> :tabN<cr>
noremap <A-l> :tabn<cr>

" CtrlP
noremap <Leader>c :Commentary<cr>
noremap <C-p> :CtrlP<cr>
noremap <Leader>pb :CtrlPBuffer<cr>
noremap <Leader>pr :CtrlPMRU<cr>

" Buffer
noremap <silent>bb :bprevious<cr>
noremap <silent>bn :bnext<cr>
noremap <silent>bx :bp <bar> bd #<cr>

" Views
noremap <A-1> :NERDTreeToggle<cr>
noremap <A-2> :ToggleGStatus<cr>
noremap <A-3> :TagbarToggle<cr>

" Git
noremap <Leader>gz :GitGutterUndoHunk<cr>
noremap <Leader>gc :Gcommit<cr>
noremap <Leader>gd :Git diff --staged<cr>
