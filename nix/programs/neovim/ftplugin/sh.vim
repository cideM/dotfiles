let b:undo_ftplugin = ""

setlocal foldmethod=indent
let b:undo_ftplugin .= '|setlocal foldmethod<'

setlocal makeprg=shellcheck\ -f\ gcc\ %
let b:undo_ftplugin .= '|setlocal makeprg<'

setlocal formatprg=shfmt
let b:undo_ftplugin .= '|setlocal formatprg<'

nnoremap <buffer> <localleader>m :silent make<CR>
