let b:undo_ftplugin = ""

compiler go

setlocal foldmethod=syntax
let b:undo_ftplugin .= '|setlocal foldmethod<'

setlocal keywordprg=go\ doc
let b:undo_ftplugin .= '|setlocal keywordprg<'

setlocal formatprg=gofmt
let b:undo_ftplugin .= '|setlocal formatprg<'

func! Goimports()
    let view = winsaveview()
    execute '%!goimports'
    call winrestview(view)
endfunc

func! Goformat()
    let view = winsaveview()
    execute '%!gofmt'
    call winrestview(view)
endfunc

func! GoimportsAndFormat()
    let view = winsaveview()
    execute '%!goimports | gofmt'
    call winrestview(view)
endfunc

nnoremap <buffer> <localleader>f :call GoimportsAndFormat()<cr>

" https://stackoverflow.com/questions/40945136/stop-highlighting-trailing-whitespace-for-go-files-in-vim
let g:go_highlight_trailing_whitespace_error=0
