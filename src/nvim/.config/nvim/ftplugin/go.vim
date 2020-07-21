let b:undo_ftplugin = ''

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

command! -buffer Imports execute '!goimports -w ' . shellescape(expand('%'))
nnoremap <buffer> <localleader>i :Imports<cr>

command! -buffer GolangCILint :lgetexpr system('golangci-lint --fast --out-format=line-number run ./...')
nnoremap <buffer> <localleader>L :GolangCILint<cr>

command! -buffer Lint :lgetexpr system('golint ' . shellescape(expand('%')))
nnoremap <buffer> <localleader>l :Lint<cr>

command! -buffer Format execute '!gofmt -w ' . shellescape(expand('%'))
nnoremap <buffer> <localleader>f :Format<cr>

nnoremap <buffer> <silent> <localleader>m :make<cr>

let b:ale_linters = ['gobuild','gopls', 'golangci-lint', 'golint']
let b:ale_fixers = ['goimports', 'gofmt']

setlocal omnifunc=v:lua.vim.lsp.omnifunc
let b:undo_ftplugin .= '|setlocal omnifunc<'

nnoremap <buffer> <silent> <localleader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer> <silent> <localleader>t <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <buffer> <silent> <localleader>D <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <buffer> <silent> <localleader>h <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <buffer> <silent> <localleader>I <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <buffer> <silent> <localleader>H <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <buffer> <silent> <localleader>r <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <buffer> <silent> <localleader>R <cmd>lua vim.lsp.buf.rename()<CR>
