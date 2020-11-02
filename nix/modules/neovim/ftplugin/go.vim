let b:undo_ftplugin = ""

compiler go

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
let b:undo_ftplugin .= '|setlocal foldmethod<'
let b:undo_ftplugin .= '|setlocal foldexpr<'

setlocal formatprg=gofmt
let b:undo_ftplugin .= '|setlocal formatprg<'

" https://github.com/leeren/dotfiles/blob/master/vim/.vim/ftplugin/go.vim
command! -buffer -range=% Gofmt let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
  \ call winrestview(b:winview)

command! -buffer -range=% Goimport let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!goimports " | 
  \ call winrestview(b:winview)

nnoremap <silent> <localleader>mc :execute 'make ' . expand('%:p:h')<CR>
nnoremap <silent> <localleader>mm :make ./...<CR>
nnoremap <silent> <localleader>i :Goimport<CR>
nnoremap <silent> <localleader>ma :call goutils#MakeprgAsyncProject()<CR>
nnoremap <silent> <localleader>tw :call goutils#RunTestAtCursor()<CR>
nnoremap <silent> <localleader>ta :call goutils#RunAllTests()<CR>
