function! reflow#Comment(type, ...)
    let l:fp = &formatprg
    set formatprg=

    if a:type ==? 'v'
        normal! '<v'>gq
    else
        normal! '[v']gq
    endif

    let &formatprg = l:fp
endfunction
