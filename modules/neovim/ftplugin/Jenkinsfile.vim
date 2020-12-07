let b:undo_ftplugin = ""

setlocal noexpandtab
let b:undo_ftplugin .= '|setlocal expandtab<'

nnoremap <buffer> <localleader>r :%retab!<cr>
