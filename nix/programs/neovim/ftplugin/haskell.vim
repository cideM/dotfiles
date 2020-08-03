let b:undo_ftplugin="setlocal formatprg< foldmethod<"

set foldmethod=indent

let &l:formatprg = brittany

nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
