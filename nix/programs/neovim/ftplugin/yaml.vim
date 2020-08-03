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
