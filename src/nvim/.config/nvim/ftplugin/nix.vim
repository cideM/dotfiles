let b:undo_ftplugin = ''

setlocal formatprg=nixpkgs-fmt
let b:undo_ftplugin .= '|setlocal formatprg<'

