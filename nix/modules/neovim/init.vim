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
set diffopt=algorithm:patience,filler,iwhiteall,indent-heuristic
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set hidden
set signcolumn=yes:2
set ignorecase
set smartcase
set inccommand=split
set path-=/usr/include
set splitbelow
set splitright
set termguicolors
set undofile

" ==============================
" =        COLORSCHEME         =
" ==============================
let g:one_allow_italics = 1
let g:yui_comments = "emphasize"

if has('unix')
	let g:seoul256_srgb = 1
endif
colorscheme seoul256-light

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
let g:EditorConfig_max_line_indicator = "exceeding"
let g:EditorConfig_preserve_formatoptions = 1

" nvim-colorizer
packadd nvim-colorizer
lua require'colorizer'.setup()

" markdown folding
let g:markdown_fold_style = 'nested'

" Sad makes replacing selections easier and just automates some tedious
" plumbing around slash search and cgn
nmap <leader>c <Plug>(sad-change-forward)
nmap <leader>C <Plug>(sad-change-backward)
xmap <leader>c <Plug>(sad-change-forward)
xmap <leader>C <Plug>(sad-change-backward)

" Otherwise the status line is overwritten with matching code parts
let g:matchup_matchparen_offscreen = {}

" No ctags for Haskell
let g:gutentags_exclude_filetypes = ['haskell']
let g:gutentags_file_list_command = 'rg\ --files'

" ========== SNEAK ==================
let g:sneak#label      = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" 2-character Sneak (default)
nmap gs <Plug>Sneak_s
nmap gS <Plug>Sneak_S
" visual-mode
xmap gs <Plug>Sneak_s
xmap gS <Plug>Sneak_S
" operator-pending-mode
omap o <Plug>Sneak_s
omap O <Plug>Sneak_S

" ========== VIM-LSC ================
set shortmess-=F
let g:lsc_auto_map = {
            \'defaults': v:true,
            \'LSClientWorkspacesymbol': 'gW'
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
            \'rust': 'rust-analyzer'
            \}
augroup LSC
    autocmd!
    autocmd CompleteDone * silent! pclose
augroup END

" ========= NVIM-LSP ================
" https://neovim.io/doc/user/lsp.html

" command! -bar -nargs=0 RestartLSP :lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd("edit")
" function! MyHighlights() abort
"     highlight LspDiagnosticsUnderline gui=undercurl
"     " Those are the actual messages in the popup, not the text/code in the
"     " buffer
"     " highlight link LspDiagnosticsWarning WarningMsg
"     " highlight link LspDiagnosticsError ErrorMsg
" endfunction

" augroup MyColors
"     autocmd!
"     autocmd ColorScheme * call MyHighlights()
" augroup END

" packadd nvim-lsp
" lua <<EOF
" local nvim_lsp = require('nvim_lsp')
" local buf_set_keymap = vim.api.nvim_buf_set_keymap
" local api = vim.api
" local util = require 'vim.lsp.util'

" -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/callbacks.lua
" local onPublishDiagnostics = function(err, method, result, client_id)
"   if not result then return end
"   local uri = result.uri
"   local bufnr = vim.uri_to_bufnr(uri)
"   if not bufnr then
"     err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
"     return
"   end

"   -- Unloaded buffers should not handle diagnostics.
"   --    When the buffer is loaded, we'll call on_attach, which sends textDocument/didOpen.
"   --    This should trigger another publish of the diagnostics.
"   --
"   -- In particular, this stops a ton of spam when first starting a server for current
"   -- unloaded buffers.
"   if not api.nvim_buf_is_loaded(bufnr) then
"     return
"   end

"   util.buf_clear_diagnostics(bufnr)

"   if result.diagnostics then
"       for _, v in ipairs(result.diagnostics) do
"         v.bufnr = client_id
"         v.lnum = v.range.start.line + 1
"         v.col = v.range.start.character + 1
"         v.text = v.message
"       end
"       util.set_loclist(result.diagnostics)
"   end

"   util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
"   util.buf_diagnostics_underline(bufnr, result.diagnostics)
"   -- util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
"   util.buf_diagnostics_signs(bufnr, result.diagnostics)
"   vim.api.nvim_command("doautocmd User LspDiagnosticsChanged")
" end

" local on_attach = function(_, bufnr)
"     vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

"     -- Mappings.
"     local opts = { noremap=true, silent=true }
"     buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua vim.lsp.buf.hover()<CR>',                 opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>h',  '<cmd>lua vim.lsp.buf.signature_help()<CR>',        opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>re', '<cmd>lua vim.lsp.buf.rename()<CR>',                opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>lua vim.lsp.buf.references()<CR>',            opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>ri', '<cmd>lua vim.lsp.buf.implementation()<CR>',        opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>',            opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>',       opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',           opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>p',  '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>',opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>ws',  '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>',opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>ds',  '<cmd>lua vim.lsp.buf.document_symbol()<CR>',opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>dh',  '<cmd>lua vim.lsp.buf.document_highlight()<CR>',opts)
"     buf_set_keymap(bufnr, 'n', '<localleader>sr',  '<cmd>lua vim.lsp.buf.server_ready()<CR>',opts)

"     -- vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
"     -- vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
"     -- vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
" end

" local configs = require'nvim_lsp/configs'

" vim.lsp.callbacks["textDocument/publishDiagnostics"] = onPublishDiagnostics

" configs.dhall = {
"     default_config = {
"             cmd = {'dhall-lsp-server'};
"             filetypes = {'dhall'};
"             root_dir = function(fname)
"                 return util.find_git_ancestor(fname) or vim.loop.os_homedir()
"             end;
"             settings = {};
"     };
" }

" local servers = {'gopls', 'rust_analyzer', 'dhall', 'purescriptls'}

" for _, lsp in ipairs(servers) do
"     if nvim_lsp[lsp].setup ~= nil and vim.fn.executable(nvim_lsp[lsp].cmd) then
"       nvim_lsp[lsp].setup { on_attach = on_attach }
"     end
" end
" EOF

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
