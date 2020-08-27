let b:undo_ftplugin = ""

setlocal foldmethod=syntax
let b:undo_ftplugin .= '|setlocal foldmethod<'

setlocal makeprg=go\ build\ ./...
let b:undo_ftplugin .= '|setlocal makeprg<'

setlocal keywordprg=go\ doc
let b:undo_ftplugin .= '|setlocal keywordprg<'

setlocal formatprg=gofmt
let b:undo_ftplugin .= '|setlocal formatprg<'

" Golangci lint
" cmd/import/main.go:168:11: ineffectual assignment to `ok` (ineffassign)
set errorformat=%E%f:%l:%c:\ %m
set errorformat+=%-Z%p^
set errorformat+=%-C%.%#
let b:undo_ftplugin .= '|setlocal errorformat<'

func! Goimports()
    let view = winsaveview()
    execute '%!goimports'
    call winrestview(view)
endfunc

func! Goformat()
    let view = winsaveview()
    execute '%!gofmt'
    call winrestview(view)
endfunc

func! GoimportsAndFormat()
    let view = winsaveview()
    execute '%!goimports | gofmt'
    call winrestview(view)
endfunc

command! -buffer GolangCILint :lgetexpr system('golangci-lint --fast --out-format=line-number run ./...')
nnoremap <buffer> <localleader>L :GolangCILint<cr>

command! -buffer Lint :lgetexpr system('golint ' . shellescape(expand('%')))
nnoremap <buffer> <localleader>l :Lint<cr>

nnoremap <buffer> <localleader>f :call GoimportsAndFormat()<cr>

nnoremap <buffer> <silent> <localleader>m :make<cr>

" https://stackoverflow.com/questions/40945136/stop-highlighting-trailing-whitespace-for-go-files-in-vim
let g:go_highlight_trailing_whitespace_error=0
