if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system("uname"), "\n", "", "")
    endif
endif

" LSP {{{
packadd nvim-lsp-latest

lua << EOF
require'nvim_lsp'.gopls.setup{}

if vim.fn.executable("dhall-lsp-server") == 1 then
    local nvim_lsp = require'nvim_lsp'
    local configs = require'nvim_lsp/configs'
    -- Check if it's already defined for when I reload this file.

    configs.dhall = {
        default_config = {
              cmd = {'dhall-lsp-server'};
              filetypes = {'dhall'};
              root_dir = function(fname)
                    return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
              end;
              settings = {};
        };
    }
end

require'nvim_lsp'.rust_analyzer.setup{}
EOF

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" }}}

" SETTINGS {{{
set shell=bash

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

set wildignore+=*/.git/*,
            \tags,
            \*/node_modules/*,
            \*/build/*,
            \*/dist/*,
            \*/compiled/*,
            \*/tmp/*
set cmdheight=2
set diffopt=algorithm:patience,filler,iwhiteall,indent-heuristic
set expandtab
set fillchars=stl:\ ,vert:\|,fold:\ 
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set hidden
set ignorecase
set noshowmode
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set inccommand=split
set nocursorline
set nonumber
set path-=/usr/include
set shiftwidth=4
set shortmess+=c
set smartcase
set splitbelow
set splitright
set completeopt-=preview
set termguicolors
set undofile

" Automatically resize windows if host window changes (e.g., creating a tmux
" split)
augroup Resize
    autocmd!
    autocmd VimResized * wincmd =
augroup END
" }}}

" MAPPINGS {{{
" KEEP THIS AT THE TOP OF ALL MAPPINGS
let mapleader = " "
let maplocalleader = ","

imap jk <Esc>

nnoremap H ^
vnoremap H ^
nnoremap L g_
vnoremap L g_

" Neovim Terminal
" http://vimcasts.org/episodes/neovim-terminal-mappings/
tnoremap <Esc> <C-\><C-n>
tnoremap <M-[> <Esc>
tnoremap <C-v><Esc> <Esc>
" }}}

let g:polyglot_disabled = ['latex', 'markdown', 'fish']

" Gutentags {{{
let g:gutentags_exclude_filetypes = ['haskell']
" }}}

" andymass/vim-matchup {{{
" This is a feature which helps you see matches that are outside of the vim
" screen, similar to some IDEs.  If you wish to disable it, use >
let g:matchup_matchparen_offscreen = {}
" }}}

" Shougo/deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

command! Reload :source $MYVIMRC
command! Conf :edit $MYVIMRC
command! Term :term fish

" Misc {{{
vmap     <Enter>    <Plug>(EasyAlign)
nnoremap <leader>m :<C-u>marks<CR>:normal! `
set wildcharm=<C-z>
nnoremap <leader>b :ls<cr>:b *
nnoremap <leader>R :set operatorfunc=reflow#Comment<cr>g@
vnoremap <leader>R :<C-u>call reflow#Comment(visualmode())<cr>
nnoremap <BS> <C-^>
" }}}

" search & replace {{{
" Normal mode
nmap <leader>c <Plug>(sad-change-forward)
nmap <leader>C <Plug>(sad-change-backward)

" Visual mode
xmap <leader>c <Plug>(sad-change-forward)
xmap <leader>C <Plug>(sad-change-backward)
" }}}

" ASTERISK {{{
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)

map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
" }}}

" fzf {{{
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

autocmd! FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fG :GFiles<CR>

let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
" }}}

" Format {{{
vmap Q <Plug>FormatVisual
nmap Q <Plug>FormatMotion
" }}}

" SNEAK {{{
let g:sneak#label      = 1
let g:sneak#use_ic_scs = 1
nmap x <Plug>Sneak_s
nmap X <Plug>Sneak_S
xmap x <Plug>Sneak_s
xmap X <Plug>Sneak_S
omap x <Plug>Sneak_s
omap X <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" }}}

" romainl/vim-qf {{{
let g:qf_auto_open_loclist = 1
nmap <leader>qq <Plug>QfCtoggle
nmap <leader>ll <Plug>QfLtoggle
" }}}

command! Update :call minpac#update()
command! Clean :call minpac#clean()

" STATUSLINE {{{
set statusline=
set statusline+=\ %t
set statusline+=\ %m 
set statusline+=\%{FugitiveStatusline()} 
set statusline+=\ %{mode()}\ 
set statusline+=%=
set statusline+=%y\ " buffer type
set statusline+=%q\ 
set statusline+=%3l:%2c\ \|
set statusline+=%3p%%\ 
" }}}

set background=light

let g:yui_folds="fade"
let g:yui_comments="fade"
let g:one_allow_italics = 1
colorscheme yui
