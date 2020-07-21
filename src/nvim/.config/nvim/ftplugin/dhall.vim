let b:undo_ftplugin = ''

set iskeyword+=.
let b:undo_ftplugin .= '|setlocal iskeyword<'

setlocal formatprg=dhall\ format
let b:undo_ftplugin .= '|setlocal formatprg<'

nnoremap <buffer> <localleader>m :make %<cr>

setlocal omnifunc=v:lua.vim.lsp.omnifunc
let b:undo_ftplugin .= '|setlocal omnifunc<'

nnoremap <buffer> <silent> <localleader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer> <silent> <localleader>t <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <buffer> <silent> <localleader>D <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <buffer> <silent> <localleader>h <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <buffer> <silent> <localleader>I <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <buffer> <silent> <localleader>H <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <buffer> <silent> <localleader>r <cmd>lua vim.lsp.buf.references()<CR>
