let b:undo_ftplugin = ""

let node_modules = luaeval(
            \'require("findUp").findUp(unpack(_A))', 
            \['node_modules',expand('%:p:h'), '/']
            \)

"""""""""""""""""""""""""
"      PRETTIER         "
"""""""""""""""""""""""""
let prettier_path = ""

if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
    let prettier_path = node_modules . "/.bin/prettier"
elseif executable("prettier")
    let prettier_path = "prettier"
end

if prettier_path !=# ""
    let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
    let b:undo_ftplugin .= '|setlocal formatprg<'
end

"""""""""""""""""""""""""
"        ESLINT         "
"""""""""""""""""""""""""
let eslint_path = ""

if node_modules !=# "false" && filereadable(node_modules . "/.bin/eslint")
    let eslint_path = node_modules . "/.bin/eslint"
elseif executable("eslint")
    let eslint_path = "eslint"
end

if eslint_path !=# ""
    let &makeprg=eslint_path . ' --format compact '
    setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
    let b:undo_ftplugin .= '|setlocal makeprg<'

    command! -bar -buffer Fix call system(eslint_path . ' --fix ' . expand('%')) | edit
    nnoremap <buffer> <silent> <localleader>f :Fix<cr>
end

let g:jsx_ext_required        = 0
let b:undo_ftplugin .= '|unlet g:jsx_ext_required'

let g:javascript_plugin_jsdoc = 1
let b:undo_ftplugin .= '|unlet g:javascript_plugin_jsdoc'

let g:javascript_plugin_flow  = 1
let b:undo_ftplugin .= '|unlet g:javascript_plugin_flow'

setlocal wildignore+=*/node_modules/*
let b:undo_ftplugin .= '|setlocal wildignore<'

setlocal foldmethod=syntax
let b:undo_ftplugin .= '|setlocal foldmethod<'

setlocal suffixesadd+=.js,.jsx,.css
let b:undo_ftplugin .= '|setlocal suffixesadd<'

nnoremap <buffer> <silent> <localleader>m :make %<cr>

command! -bar -buffer JestSplit :split | execute 'terminal jest '. expand('%')
nnoremap <buffer> <silent> <localleader>ts :JestSplit<cr>

command! -bar -buffer JestSplitWatch :split | execute 'terminal jest --watch '. expand('%')
nnoremap <buffer> <silent> <localleader>tw :JestSplitWatch<cr>

let b:ale_fixers = ['eslint', 'prettier']
let b:ale_linters = ['eslint']
