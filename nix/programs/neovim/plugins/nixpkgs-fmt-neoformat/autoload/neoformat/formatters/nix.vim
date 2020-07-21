function! neoformat#formatters#nix#enabled() abort
    return ['nixpkgsfmt']
endfunction

function! neoformat#formatters#nix#nixpkgsfmt() abort
    return {
        \ 'exe': 'nixpkgs-fmt',
        \ 'args': [],
        \ 'stdin': 1
        \ }
endfunction
