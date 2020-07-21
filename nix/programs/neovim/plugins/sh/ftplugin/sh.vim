let b:undo_ftplugin = ''

setlocal makeprg=shellcheck\ -f\ gcc\ %
let b:undo_ftplugin .= '|setlocal makeprg<'

setlocal formatprg=shfmt
let b:undo_ftplugin .= '|setlocal formatprg<'

nnoremap <buffer> <localleader>m :make<CR>
