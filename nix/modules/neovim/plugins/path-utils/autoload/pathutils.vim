function! pathutils#SetPath(...)
    call luaeval('require("path-utils").set_path()')
endfunction
