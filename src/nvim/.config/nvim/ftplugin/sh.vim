let b:undo_ftplugin="setlocal makeprg<"

setlocal makeprg=shellcheck\ -f\ gcc\ %
nnoremap <buffer> <localleader>m :make<CR>
