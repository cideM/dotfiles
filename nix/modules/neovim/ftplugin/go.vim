let b:undo_ftplugin = ""

compiler go

setlocal foldmethod=syntax
let b:undo_ftplugin .= '|setlocal foldmethod<'

setlocal keywordprg=go\ doc
let b:undo_ftplugin .= '|setlocal keywordprg<'

setlocal formatprg=gofmt
let b:undo_ftplugin .= '|setlocal formatprg<'

" https://github.com/leeren/dotfiles/blob/master/vim/.vim/ftplugin/go.vim
command! -buffer -range=% Gofmt let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
  \ call winrestview(b:winview)

command! -buffer -range=% Goimport let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!goimports " | 
  \ call winrestview(b:winview)

" I don't like stuff that just happens
" augroup Goupdate
"   autocmd!
"   autocmd BufWritePre <buffer> Gofmt
"   autocmd BufWritePre <buffer> Goimport
" augroup END

" https://stackoverflow.com/questions/40945136/stop-highlighting-trailing-whitespace-for-go-files-in-vim
let g:go_highlight_trailing_whitespace_error=0

command! -buffer GolangCILint :lgetexpr system('golangci-lint run --print-issued-lines=false')
nnoremap <buffer> <localleader>L :GolangCILint<cr>

nnoremap <silent> <localleader>tw :call goutils#RunTestAtCursor()<CR>
nnoremap <silent> <localleader>ta :call goutils#RunAllTests()<CR>
" make current directory
nnoremap <silent> <localleader>mm :execute 'make ' . expand('%:p:h')<CR>
" make entire project
nnoremap <silent> <localleader>mp :call goutils#MakeprgAsyncProject()<CR>
" nnoremap <silent> <localleader>mp :make ./...<CR>
