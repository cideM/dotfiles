let b:undo_ftplugin = ""

let &l:formatprg = 'prettier --parser yaml --stdin-filepath %'
let b:undo_ftplugin .= '|unlet formatprg<'
