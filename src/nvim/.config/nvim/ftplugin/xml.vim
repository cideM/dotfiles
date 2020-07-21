let b:undo_ftplugin="setlocal formatprg<"

let &l:formatprg = b:prettier_exe . ' --stdin-filepath %'
