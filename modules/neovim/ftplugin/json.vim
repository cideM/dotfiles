let b:undo_ftplugin="setlocal formatprg< foldmethod<"

setlocal foldmethod=indent

let &l:formatprg = 'prettier --stdin-filepath %'
