let b:undo_ftplugin="setlocal makeprg< formatprg<"

setlocal makeprg=cargo\ check 
setlocal formatprg=rustfmt

let b:ale_linters = ['cargo', 'rust-analyzer']
let b:ale_fixers = ['rustfmt']
