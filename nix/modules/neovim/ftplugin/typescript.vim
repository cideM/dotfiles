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
"        TSLINT         "
"""""""""""""""""""""""""
let tslint_path = ""

if node_modules !=# "false" && filereadable(node_modules . "/.bin/tslint")
    let tslint_path = node_modules . "/.bin/tslint"
elseif executable("tslint")
    let tslint_path = "tslint"
end

if tslint_path !=# ""
    let &makeprg=tslint_path . ' --format compact '
    setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
    let b:undo_ftplugin .= '|setlocal makeprg<'

    command! -bar -buffer Fix call system(tslint_path . ' --fix ' . expand('%')) | edit
    nnoremap <buffer> <silent> <localleader>f :Fix<cr>
end

set wildignore+=*/node_modules/*
let b:undo_ftplugin .= '|setlocal wildignore<'

setlocal suffixesadd+=.ts,.tsx,.css
let b:undo_ftplugin .= '|setlocal suffixesadd<'
