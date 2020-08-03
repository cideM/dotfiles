let b:undo_ftplugin = ''
setlocal makeprg=luacheck\ --formatter\ plain
let b:undo_ftplugin .= '|setlocal makeprg<'

nnoremap <buffer> <silent> <localleader>m :make %<cr>
