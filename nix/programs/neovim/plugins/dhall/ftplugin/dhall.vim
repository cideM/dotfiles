let b:undo_ftplugin = ''

set iskeyword+=.
let b:undo_ftplugin .= '|setlocal iskeyword<'

setlocal formatprg=dhall\ format
let b:undo_ftplugin .= '|setlocal formatprg<'

nnoremap <buffer> <localleader>m :make %<cr>
