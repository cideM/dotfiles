let b:undo_ftplugin = ""

compiler go

let b:ale_linters = ['golangci-lint']
let b:ale_fixers = ['goimports', 'gofmt']

setlocal foldmethod=syntax
let b:undo_ftplugin .= '|setlocal foldmethod<'

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
nnoremap <silent> <localleader>i :Goimport
nnoremap <silent> <localleader>ma :call goutils#MakeprgAsyncProject()<CR>
nnoremap <silent> <localleader>tw :call goutils#RunTestAtCursor()<CR>
nnoremap <silent> <localleader>ta :call goutils#RunAllTests()<CR>
