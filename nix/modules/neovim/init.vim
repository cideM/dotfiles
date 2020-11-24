" ==============================
" =       GENERAL SETTINGS     =
" ==============================
" Don't load the built-in plugin so that the custom 'matchup' plugin is the
" only such plugin that is active.
" This doesn't seem to work
let g:loaded_matchit = 1

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
set signcolumn=auto:3
set ignorecase
set number
" set completeopt-=preview
set completeopt=menuone,noinsert,noselect
set smartcase
set inccommand=split
set path-=/usr/include
set splitbelow
set foldlevelstart=99
set splitright
set termguicolors
set undofile

set statusline=
set statusline+=\ %f
set statusline+=\ %m 
set statusline+=\%{FugitiveStatusline()} 
set statusline+=\ %{mode()}\ 
set statusline+=%=
set statusline+=%y\ " buffer type
set statusline+=%q\ 
set statusline+=%3l:%2c\ \|
set statusline+=%3p%%\ 

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

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" ==============================
" =        COLORSCHEME         =
" ==============================
let g:one_allow_italics = 1
let g:yui_comments = "emphasize"
let g:sonokai_enable_italic = 1
let g:sonokai_diagnostic_line_highlight = 1
let g:edge_enable_italic = 1
colorscheme yui

" Call my own SetPath function so that every git file is added to path. Let's
" me get most of FZF without using FZF
augroup SetPath
    autocmd!
    autocmd BufEnter,DirChanged * call pathutils#SetPath()
augroup END
command! -nargs=0 UpdatePath :call pathutils#SetPath()

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
tnoremap <Esc>      <C-\><C-n>
tnoremap <A-h>      <C-\><C-N><C-w>h
tnoremap <A-j>      <C-\><C-N><C-w>j
tnoremap <A-k>      <C-\><C-N><C-w>k
tnoremap <A-l>      <C-\><C-N><C-w>l
inoremap <A-h>      <C-\><C-N><C-w>h
inoremap <A-j>      <C-\><C-N><C-w>j
inoremap <A-k>      <C-\><C-N><C-w>k
inoremap <A-l>      <C-\><C-N><C-w>l
nnoremap <A-h>      <C-w>h
nnoremap <A-j>      <C-w>j
nnoremap <A-k>      <C-w>k
nnoremap <A-l>      <C-w>l
" Open terminal in directory of current file
nnoremap <leader>T  :split <Bar> lcd %:p:h <Bar> term<CR>

" Leave insert mode with jk
imap jk             <Esc>

" Convenience mappings for calling :grep
nnoremap <leader>gg :grep!<space>
nnoremap <leader>gw :grep! -wF ""<left>

" Just calls formatprg on entire buffer
nmap     <leader>Q  :call FormatBuffer()<cr>

nnoremap <leader>f  :find *
" nnoremap <leader>b  :ls<cr>:buffer<Space>

vmap     <Enter>    <Plug>(EasyAlign)

nnoremap <leader>s  :nohlsearch<CR>

" Reflow comments according to max line length. This temporarily unsets
" formatprg so cindent (?) is used. I don't know... this mostly just works.
nnoremap <leader>R  :set operatorfunc=reflow#Comment<cr>g@
vnoremap <leader>R  :<C-u>call reflow#Comment(visualmode())<cr>

" Switch to alternate buffer with backspace
nnoremap <BS>       <C-^>

" ==============================
" =          PLUGINS           =
" ==============================

" ======= ANY JUMP ==================
let g:any_jump_disable_default_keybindings = 1
nnoremap <leader>J :AnyJump<CR>
xnoremap <leader>J :AnyJumpVisual<CR>
nnoremap <leader>ab :AnyJumpBack<CR>
nnoremap <leader>al :AnyJumpLastResults<CR>

" ======= VIMTEX ====================
let g:tex_flavor = 'latex'

" ======= FERN ======================
" Drawer style, does not have opener
nmap <leader>ee :Fern . -drawer<CR>
" Current file
nmap <leader>eh :Fern %:h -drawer<CR>
" Focus Fern
nmap <leader>ef :FernDo :<CR>
nmap <leader>el <Plug>(fern-action-leave)
nmap <leader>eo <Plug>(fern-action-open:select)

" ======= STARTIFY ==================
let g:startify_change_to_dir = 0

" ======= EDITORCONFIG ==============
let g:EditorConfig_max_line_indicator = "exceeding"
let g:EditorConfig_preserve_formatoptions = 1

" ======= NVIM COLORIZER ============
packadd nvim-colorizer
lua require'colorizer'.setup()

" ======= TELESCOPE =================
packadd telescope
nnoremap <leader>p   <cmd>Telescope find_files<cr>
nnoremap <leader>b   <cmd>Telescope buffers<cr>
nnoremap <leader>tg  <cmd>Telescope live_grep<cr>
nnoremap <leader>tds <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>tws <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>tm  <cmd>Telescope marks<cr>
nnoremap <leader>tgf <cmd>Telescope git_files<cr>
nnoremap <leader>tl  <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>tw  <cmd>Telescope grep_string<cr>
nnoremap <leader>tp  <cmd>Telescope builtin<cr>
nnoremap <leader>ta  <cmd>Telescope tags<cr>
nnoremap <leader>tt  <cmd>Telescope current_buffer_tags<cr>

" ======= NVIM-TREE LUA =============
" https://github.com/kyazdani42/nvim-tree.lua
let g:lua_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ }
let g:lua_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:lua_tree_icons = {
    \ 'default': ' ',
    \ 'symlink': '»',
    \ 'git': {
    \   'unstaged': "+",
    \   'staged': "*",
    \   'unmerged': "o",
    \   'renamed': "r",
    \   'untracked': "u"
    \   },
    \ 'folder': {
    \   'default': ">",
    \   'open': "v"
    \   }
    \ }

" ======= MARKDOWN FOLDING ==========
let g:markdown_fold_style = 'nested'

" ======= SAD =======================
" Sad makes replacing selections easier and just automates some tedious
" plumbing around slash search and cgn.
map <leader>c <Plug>(sad-change-forward)
map <leader>C <Plug>(sad-change-backward)

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

" ======= COMPLETION-NVIM ===========
autocmd BufEnter * lua require'completion'.on_attach()
imap  <c-j> <Plug>(completion_next_source)
imap  <c-k> <Plug>(completion_prev_source)
let g:completion_chain_complete_list = {
    \'default': [
    \   {'complete_items': ['lsp']},
    \   {'complete_items': ['buffers']},
    \   {'complete_items': ['tags']},
    \   {'complete_items': ['path']},
    \]
    \}

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
omap o <Plug>Sneak_s
omap O <Plug>Sneak_S
" 2-character Sneak (default)
map <leader>j <Plug>Sneak_s
map <leader>k <Plug>Sneak_S


" ========= NVIM-LSP ================
" https://neovim.io/doc/user/lsp.html

command! -bar -nargs=0 RestartLSP :lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd("edit")

packadd nvim-lsp
lua <<EOF
local nvim_lsp = require'lspconfig'
local buf_set_keymap = vim.api.nvim_buf_set_keymap
local api = vim.api

local on_attach = function(_, bufnr)
    api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap(bufnr, 'n', '<localleader>K',  '<cmd>lua vim.lsp.buf.hover()<CR>',                 opts)
    buf_set_keymap(bufnr, 'n', '<localleader>h',  '<cmd>lua vim.lsp.buf.signature_help()<CR>',        opts)
    buf_set_keymap(bufnr, 'n', '<localleader>re', '<cmd>lua vim.lsp.buf.rename()<CR>',                opts)
    buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>lua vim.lsp.buf.references()<CR>',            opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ri', '<cmd>lua vim.lsp.buf.implementation()<CR>',        opts)
    buf_set_keymap(bufnr, 'n', '<localleader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>',            opts)
    buf_set_keymap(bufnr, 'n', '<localleader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>',       opts)
    buf_set_keymap(bufnr, 'n', '<localleader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',           opts)
    buf_set_keymap(bufnr, 'n', '<localleader>p',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ws',  '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ds',  '<cmd>lua vim.lsp.buf.document_symbol()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>dh',  '<cmd>lua vim.lsp.buf.document_highlight()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>sr',  '<cmd>lua vim.lsp.buf.server_ready()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>j',  '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>l',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',opts)

    -- api.nvim_command [[autocmd User LspDiagnosticsChanged   lua vim.lsp.diagnostic.set_loclist()]]
    -- api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    -- api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    -- api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
end

local configs = require'lspconfig/configs'

nvim_lsp.util.default_config = vim.tbl_extend(
  "force",
  nvim_lsp.util.default_config,
  { on_attach = on_attach }
)

vim.lsp.callbacks['textDocument/hover'] = function(_, method, result)
  vim.lsp.util.focusable_float(method, function()
    if not (result and result.contents) then
      -- return { 'No information available' }
      return
    end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      -- return { 'No information available' }
      return
    end
    local bufnr, winnr = vim.lsp.util.fancy_floating_markdown(markdown_lines, {
      pad_left = 2; pad_right = 2;
      pad_top = 2; pad_bottom = 2; -- add this line for vertical padding
      max_width = 80; -- add this line to set the maximal width of hover float
    })
    vim.lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
    return bufnr, winnr
  end)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 0
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

if not configs.dhall then
    configs.dhall = {
        default_config = {
                cmd = {'dhall-lsp-server'};
                filetypes = {'dhall'};
                root_dir = function(fname)
                    return vim.lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
                end;
                settings = {};
        };
    }
end

nvim_lsp.purescriptls.setup{}
nvim_lsp.rust_analyzer.setup{}
nvim_lsp.gopls.setup{}
nvim_lsp.dhall.setup{}
EOF

" ========= NVIM-TREESITTER =========
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
