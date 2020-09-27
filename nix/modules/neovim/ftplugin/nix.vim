let b:undo_ftplugin = ""

setlocal formatprg=nixpkgs-fmt
let b:undo_ftplugin .= '|setlocal formatprg<'

setlocal foldmethod=indent
let b:undo_ftplugin .= '|setlocal foldmethod<'
