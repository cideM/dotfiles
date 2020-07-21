let b:undo_ftplugin="setlocal formatprg< foldmethod<"

set foldmethod=indent

let &l:formatprg = 'hindent'

nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
