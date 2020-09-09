function! goutils#RunTestAtCursor(...)
    call luaeval(
                \'require("goutils").run_tests(unpack(_A))',
                \[expand('<cword>')]
                \)
endfunction

function! goutils#RunAllTests(...)
    call luaeval('require("goutils").run_tests()')
endfunction
