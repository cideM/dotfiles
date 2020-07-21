function! s:Format(type, ...)
    let l:saved_view = winsaveview()

    " Visual character or line
    if a:type ==? 'v'
        normal! '<v'>gq
    " Motion
    else
        normal! '[v']gq
    endif

    if v:shell_error > 0
        silent undo
        redraw
        echoerr 'Formatprg ' 
                    \. &formatprg 
                    \. ' exited with status ' 
                    \. v:shell_error 
                    \. '.'
        call winrestview(l:saved_view)
    endif

    unlet l:saved_view
endfunction

function! s:FormatBuffer()
        normal ms
        normal ggVGgq
        normal `s
endfunction

command! FormatBuffer call <SID>FormatBuffer()

vnoremap <silent> <Plug>FormatVisual
            \ :<c-u>call <SID>Format(visualmode())<cr>

nnoremap <silent> <Plug>FormatMotion 
            \ :set operatorfunc=<SID>Format
            \<cr>g@
