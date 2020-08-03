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

nnoremap <buffer> <localleader>i :%!goimports<CR>

command! -buffer GolangCILint :lgetexpr system('golangci-lint --fast --out-format=line-number run ./...')
nnoremap <buffer> <localleader>L :GolangCILint<cr>

command! -buffer Lint :lgetexpr system('golint ' . shellescape(expand('%')))
nnoremap <buffer> <localleader>l :Lint<cr>

nnoremap <buffer> <localleader>f ms:%!gofmt<CR>`s

nnoremap <buffer> <silent> <localleader>m :make<cr>

let b:ale_linters = ['gobuild', 'gopls', 'golangci-lint']
let b:ale_fixers = ['goimports', 'gofmt']
