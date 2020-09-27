let b:undo_ftplugin = ""

set wildignore+=*/node_modules/*
let b:undo_ftplugin .= '|setlocal suffixesadd<'

setlocal makeprg=tslint\ --format\ unix
let b:undo_ftplugin .= '|setlocal makeprg<'

setlocal formatprg=prettier\ --stdin-filepath\ %
let b:undo_ftplugin .= '|setlocal formatprg<'
