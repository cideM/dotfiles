let b:undo_ftplugin = ""

setlocal formatprg=purty\ -
let b:undo_ftplugin .= '|setlocal formatprg<'

command! -buffer SpagoTags :execute '!spago docs --format ctags'

let b:ale_linters = []

