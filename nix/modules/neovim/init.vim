if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', "", "")
    endif
endif

packadd nvim-lsp
luafile ~/.config/nvim/lsp.lua

packadd nvim-treesitter
luafile ~/.config/nvim/treesitter.lua

" backup files
    if !isdirectory("$HOME/.config/nvim/.swap")
        call mkdir($HOME . "/.config/nvim/.swap", "p", 0700)
        set directory=~/.config/nvim/.swap//
    endif
    if !isdirectory("$HOME/.config/nvim/.backup")
        call mkdir($HOME . "/.config/nvim/.backup", "p", 0700)
        set backupdir=~/.config/nvim/.backup//
    endif
    if !isdirectory("$HOME/.config/nvim/.undo")
        call mkdir($HOME . "/.config/nvim/.undo", "p", 0700)
        set undodir=~/.config/nvim/.undo//
    endif

set background=light
set shell=bash
set formatoptions-=t
" https://www.reddit.com/r/vim/comments/25g1sp/why_doesnt_vim_syntax_like_my_shell_files/
let g:is_posix = 1
set wildignore+=*/.git/*,
            \*/node_modules/*,
            \*/build/*,
            \*/dist/*,
            \*/compiled/*,
            \*/tmp/*
set diffopt=algorithm:patience,filler,iwhiteall,indent-heuristic
set expandtab
set fillchars=stl:\ ,vert:\|,fold:\ 
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set foldlevelstart=99
set hidden
set signcolumn=auto:2
set ignorecase
set noshowmode
set updatetime=100
set nolist
" set listchars=tab:·\ ,extends:›,precedes:‹,nbsp:·,trail:·
set inccommand=split
set nocursorline
set nonumber
set path-=/usr/include
set completeopt=menu,menuone,noselect
set shiftwidth=4
set shortmess+=c
set smartcase
set splitbelow
set splitright
set termguicolors
set undofile

" Automatically resize windows if host window changes (e.g., creating a tmux
" split)
augroup Resize
    autocmd!
    autocmd VimResized * wincmd =
augroup END

augroup SetPath
    autocmd!
    autocmd BufEnter,DirChanged * call pathutils#SetPath()
augroup END

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

function! FormatBuffer()
  let view = winsaveview()
  " https://vim.fandom.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
  normal ix
  normal x
  try | silent undojoin | catch | endtry
  keepjumps normal ggVGgq
  call winrestview(view)
endfunction

let g:EditorConfig_max_line_indicator = "exceeding"

" KEEP THIS AT THE TOP OF ALL MAPPINGS
let mapleader = " "
let maplocalleader = ","

imap jk <Esc>

nnoremap <leader>gg :grep<space>
nnoremap <leader>gw :grep -wF ""<left>

nmap <leader>Q :call FormatBuffer()<cr>

nnoremap <leader>f :find *
" nnoremap <leader>b :buffer *
nnoremap <leader>tt :ts *
nnoremap <leader>ts :sts *
nnoremap <leader>b :ls<cr>:buffer<Space>

vmap     <Enter>    <Plug>(EasyAlign)

nnoremap <leader>R :set operatorfunc=reflow#Comment<cr>g@
vnoremap <leader>R :<C-u>call reflow#Comment(visualmode())<cr>

nnoremap <BS> <C-^>

" sandwich
    " https://github.com/machakann/vim-sandwich/blob/master/plugin/sandwich.vim
    let g:sandwich_no_default_key_mappings = 1
    silent! nmap <unique><silent> <C-s>d <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> <C-s>r <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> <C-s>db <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
    silent! nmap <unique><silent> <C-s>rb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
    
    " https://github.com/machakann/vim-sandwich/blob/master/plugin/textobj/sandwich.vim
    let g:textobj_sandwich_no_default_key_mappings = 1
    " same as original
    silent! omap <unique> ib <Plug>(textobj-sandwich-auto-i)
    silent! xmap <unique> ib <Plug>(textobj-sandwich-auto-i)
    silent! omap <unique> ab <Plug>(textobj-sandwich-auto-a)
    silent! xmap <unique> ab <Plug>(textobj-sandwich-auto-a)

    silent! omap <unique> ic <Plug>(textobj-sandwich-query-i)
    silent! xmap <unique> ic <Plug>(textobj-sandwich-query-i)
    silent! omap <unique> ac <Plug>(textobj-sandwich-query-a)
    silent! xmap <unique> ac <Plug>(textobj-sandwich-query-a)

    " https://github.com/machakann/vim-sandwich/blob/master/plugin/operator/sandwich.vim
    let g:operator_sandwich_no_default_key_mappings = 1
    " add
    silent! nmap <unique> <C-s>a <Plug>(operator-sandwich-add)
    silent! xmap <unique> <C-s>a <Plug>(operator-sandwich-add)
    silent! omap <unique> <C-s>a <Plug>(operator-sandwich-g@)

    " delete
    silent! xmap <unique> <C-s>d <Plug>(operator-sandwich-delete)

    " replace
    silent! xmap <unique> <C-s>r <Plug>(operator-sandwich-replace)

" vim-sneak
    let g:sneak#label      = 1
    let g:sneak#use_ic_scs = 1
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
    omap o <Plug>Sneak_s
    omap O <Plug>Sneak_S

" LSP
  " https://neovim.io/doc/user/lsp.html
  command! -bar -nargs=0 RestartLSP :lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd("edit")

" Neovim Terminal
  command! -nargs=0 TermHere execute 'split | lcd ' . expand('%:p:h') . ' | term fish'
  " http://vimcasts.org/episodes/neovim-terminal-mappings/
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>

" markdown folding
    let g:markdown_fold_style = 'nested'

" sad
    nmap <leader>c <Plug>(sad-change-forward)
    nmap <leader>C <Plug>(sad-change-backward)
    xmap <leader>c <Plug>(sad-change-forward)
    xmap <leader>C <Plug>(sad-change-backward)

" andymass/vim-matchup
    let g:matchup_matchparen_offscreen = {}

" gutentags
    let g:gutentags_exclude_filetypes = ['haskell']
    let g:gutentags_file_list_command = 'rg\ --files'

" romainl/vim-qf
    let g:qf_auto_open_loclist = 1
    nmap <leader>qq <Plug>QfCtoggle
    nmap <leader>ll <Plug>QfLtoggle

" mundo
    nnoremap <leader>u :MundoToggle<CR>

function! LspCount() abort
    let sl = ''
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let errors = 0

        if luaeval("not (vim.lsp.util.buf_diagnostics_count([[Error]]) == nil)")
            let errors = luaeval("vim.lsp.util.buf_diagnostics_count([[Error]])")
        endif

        let sl.='E:' . errors

        let warnings = 0

        if luaeval("not (vim.lsp.util.buf_diagnostics_count([[Warning]]) == nil)")
            let warnings = luaeval("vim.lsp.util.buf_diagnostics_count([[Warning]])")
        endif

        let sl.=' W:' . warnings
    else
        let sl = 'off'
    endif
    return sl
endfunction

set statusline=
set statusline+=\ %f
set statusline+=\ %m 
set statusline+=\%{FugitiveStatusline()} 
set statusline+=\ %{mode()}\ 
set statusline+=\%{LspCount()}
set statusline+=%=
set statusline+=\%{gutentags#statusline('[',']\ ')}
set statusline+=%y\ " buffer type
set statusline+=%q\ 
set statusline+=%3l:%2c\ \|
set statusline+=%3p%%\ 

let g:one_allow_italics = 1
let g:yui_comments = "emphasize"
colorscheme iceberg
