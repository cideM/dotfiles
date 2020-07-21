let b:undo_ftplugin = ""

setlocal shiftwidth=4
let b:undo_ftplugin .= '|setlocal shiftwidth<'

setlocal tabstop=4
let b:undo_ftplugin .= '|setlocal tabstop<'

setlocal noexpandtab
let b:undo_ftplugin .= '|setlocal noexpandtab<'

setlocal shiftwidth=4
let b:undo_ftplugin .= '|setlocal shiftwidth<'

nnoremap <buffer> <localleader>r :%retab!<cr>

