function! s:Format(type, ...)
    " Visual character or line
    if a:type ==? 'v'
        normal! '<v'>
        Neoformat
    " Motion
    else
        normal! '[v']
        Neoformat
    endif

    execute "normal! \<Esc>"
endfunction

vnoremap <Plug>FormatVisual
            \ :<c-u>call <SID>Format(visualmode())<cr>

nnoremap <Plug>FormatMotion
            \ :set operatorfunc=<SID>Format
            \<cr>g@
