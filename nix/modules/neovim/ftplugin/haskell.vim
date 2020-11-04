let b:undo_ftplugin="setlocal formatprg< foldmethod<"

set foldmethod=indent

set formatprg=ormolu

nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
