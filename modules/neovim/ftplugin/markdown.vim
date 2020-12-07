let b:undo_ftplugin = ""

let &l:formatprg = 'prettier --parser markdown --stdin-filepath %'
let b:undo_ftplugin .= '|unlet formatprg<'
