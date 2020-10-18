" ==============================
" =       GENERAL SETTINGS     =
" ==============================
set background=light
set formatoptions-=t
set wildignore+=*/.git/*,
            \*/node_modules/*,
            \*/build/*,
            \*/dist/*,
            \*/compiled/*,
            \*/tmp/*
set diffopt=algorithm:patience,filler,indent-heuristic,closeoff
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set hidden
set signcolumn=yes:2
set ignorecase
set completeopt-=preview
set smartcase
set inccommand=split
set path-=/usr/include
set splitbelow
set splitright
set termguicolors
set undofile

" https://github.com/neovim/neovim/issues/13113
" EVERYTHING. IS. BROKEN. ALL THE FUCKING TIME
" You open your favorite program and one day it's broken! Why? THE FUCK DO I
" CARE. There's not a single fucking program developed in the last 10 years
" that's not broken ALL THE FUCKING TIME.
augroup FUCK_EVERYTHING
    autocmd!
    autocmd Filetype typescript setlocal formatexpr=
augroup END

" Automatically resize windows if host window changes (e.g., creating a tmux
" split)
augroup Resize
    autocmd!
    autocmd VimResized * wincmd =
augroup END

" ==============================
" =        COLORSCHEME         =
" ==============================
colorscheme yui
let g:one_allow_italics = 1
let g:yui_comments = "emphasize"

" Call my own SetPath function so that every git file is added to path. Let's
" me get most of FZF without using FZF
augroup SetPath
    autocmd!
    autocmd BufEnter,DirChanged * call pathutils#SetPath()
augroup END

" Built-in Neovim feature that highlights yanked code.
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" Format the buffer with the current formatprg. Most of the custom code here
" is just so my jump list isn't cluttered and I always end up at the first
" line when undoing a FormatBuffer call. See the linked post.
function! FormatBuffer()
  let view = winsaveview()
  " https://vim.fandom.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
  normal ix
  normal x
  try | silent undojoin | catch | endtry
  keepjumps normal ggVGgq
  call winrestview(view)
endfunction

" ==============================
" =          MAPPINGS          =
" ==============================
let mapleader = " "
let maplocalleader = ","

" ==============================
" =          TERMINAL          =
" ==============================
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" Open terminal in directory of current file
nnoremap <leader>t :split <Bar> lcd %:p:h <Bar> term<CR>

" Leave insert mode with jk
imap jk <Esc>

" Convenience mappings for calling :grep
nnoremap <leader>gg :grep<space>
nnoremap <leader>gw :grep -wF ""<left>

" Just calls formatprg on entire buffer
nmap <leader>Q :call FormatBuffer()<cr>

nnoremap <leader>f :find *
nnoremap <leader>b :ls<cr>:buffer<Space>

vmap     <Enter>    <Plug>(EasyAlign)

" Reflow comments according to max line length. This temporarily unsets
" formatprg so cindent (?) is used. I don't know... this mostly just works.
nnoremap <leader>R :set operatorfunc=reflow#Comment<cr>g@
vnoremap <leader>R :<C-u>call reflow#Comment(visualmode())<cr>

" Switch to alternate buffer with backspace
nnoremap <BS> <C-^>

" ==============================
" =          PLUGINS           =
" ==============================

" ======= EDITORCONFIG ==============
let g:EditorConfig_max_line_indicator = "exceeding"
let g:EditorConfig_preserve_formatoptions = 1

" ======= VIM QF ====================
let g:qf_auto_open_quickfix = 1
let g:qf_auto_open_loclist  = 1

" ======= NVIM COLORIZER ============
packadd nvim-colorizer
lua require'colorizer'.setup()

" ======= MARKDOWN FOLDING ==========
let g:markdown_fold_style = 'nested'

" ======= SAD =======================
" Sad makes replacing selections easier and just automates some tedious
" plumbing around slash search and cgn. It's just an upgrade over the built-in
" c mapping. C is still the old functionality.
map c <Plug>(sad-change-forward)
map <leader>c <Plug>(sad-change-backward)

" ======= ASTERISK ==================
" This should override the mappings for * and # which are provided by sad.
" Use stay motions per default, meaning pressing * won't jump to the first
" match.
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

" ======= MATCHUP ===================
" Otherwise the status line is overwritten with matching code parts
let g:matchup_matchparen_offscreen = {}

" ======= GUTENTAGS =================
" No ctags for Haskell
let g:gutentags_exclude_filetypes = ['haskell', 'purs', 'purescript']
let g:gutentags_file_list_command = 'rg\ --files'

" ======= SNEAK =====================
let g:sneak#label      = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" 2-character Sneak (default)
map <leader>j <Plug>Sneak_s
map <leader>k <Plug>Sneak_S

" ========== ALE ====================
let g:ale_go_golangci_lint_options = 'fast'
nmap <leader>ad <Plug>(ale_detail)
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-f> <Plug>(ale_fix)

" ========== VIM-LSC ================
set shortmess-=F
let g:lsc_auto_map = {
            \'defaults': v:true,
            \'WorkspaceSymbol': 'gW'
            \}
let g:lsc_server_commands = {
            \'go': 'gopls',
            \'dhall': 'dhall-lsp-server',
            \'purescript': {
            \   'command': 'purescript-language-server --stdio',
            \   'workspace_config': {
            \       'addSpagoSources': 'true'
            \   }
            \},
            \'rust': 'rust-analyzer',
            \'typescript': 'typescript-language-server --stdio'
            \}
augroup LSC
    autocmd!
    autocmd CompleteDone * silent! pclose
augroup END

" ==============================
" =     NVIM TREESITTER        =
" ==============================
packadd nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {},     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
}
EOF
