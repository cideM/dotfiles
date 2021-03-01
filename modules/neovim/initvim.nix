{ config, lib, pkgs, ... }:
let
  cfg = config.programs.neovim;

in
''
  " ==============================
  " =       GENERAL SETTINGS     =
  " ==============================
  " Don't load the built-in plugin so that the custom 'matchup' plugin is the
  " only such plugin that is active.
  " This doesn't seem to work
  let g:loaded_matchit = 1

  set background=light
  set foldmethod=syntax
  set number
  set tabstop=4 
  set shiftwidth=2
  set noequalalways
  set formatoptions=tcrqjn
  set wildignore+=*.git/*,
              \*node_modules/*,
              \*public/*,
              \nix/sources.nix,
              \*.clj-kondo*,
              \package-lock.json,
              \*.min.*,
              \*.map,
              \*.idea,
              \*build/*,
              \*dist/*,
              \*compiled/*,
              \*tmp/*
  set diffopt=algorithm:patience,filler,indent-heuristic,closeoff,iwhite
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set hidden
  set signcolumn=yes:2
  set ignorecase
  set completeopt=menuone,noselect
  set smartcase
  set inccommand=split
  set path-=/usr/include
  set splitbelow
  set foldlevelstart=99
  set splitright
  set termguicolors
  set undofile
  colorscheme yui

  " https://github.com/neovim/neovim/issues/13113
  augroup Foo
      autocmd!
      autocmd Filetype typescript setlocal formatexpr=
  augroup END

  augroup quickfix
      autocmd!
      autocmd QuickFixCmdPost [^l]* cwindow
      autocmd QuickFixCmdPost l* lwindow

      autocmd FileType qf nnoremap <buffer> <left> :colder<cr>
      autocmd FileType qf nnoremap <buffer> <right> :cnewer<cr>
  augroup END

  function! ReflowComment(type, ...)
      let l:fp = &formatprg
      set formatprg=

      if a:type ==? 'v'
          normal! '<v'>gq
      else
          normal! '[v']gq
      endif

      let &formatprg = l:fp
  endfunction

  " " Call my own SetPath function so that every git file is added to path. Let's
  " " me get most of FZF without using FZF
  " augroup SetPath
  "     autocmd!
  "     autocmd BufEnter,DirChanged * call pathutils#SetPath()
  " augroup END
  " command! -nargs=0 UpdatePath :call pathutils#SetPath()

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

  command! -bar -nargs=1 Find new | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile | 0r!fd <args>
  command! -bar -nargs=1 FindAll new | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile | 0r!fd -uu <args>
  command! -bar -nargs=1 FindV vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile | 0r!fd <args>
  command! -bar -nargs=1 FindAllV vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile | 0r!fd -uu <args>

  let mapleader = " "
  let maplocalleader = ","

  nnoremap <leader>/  :nohlsearch<CR>

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

  nnoremap <leader>T  :split <Bar> lcd %:p:h <Bar> term fish<CR>
  nnoremap <leader>t  :split <Bar> term fish<CR>

  imap jk             <Esc>

  nnoremap <leader>gg :grep!<space>
  nnoremap <leader>gw :grep! -wF 

  " Just calls formatprg on entire buffer
  nmap     <leader>q  :call FormatBuffer()<cr>

  nnoremap <leader>F  :find *
  nnoremap <leader>B  :ls<cr>:buffer<Space>

  vmap     <Enter>    <Plug>(EasyAlign)

  " Reflow comments according to max line length. This temporarily unsets
  " formatprg so cindent (?) is used. I don't know... this mostly just works.
  nnoremap <leader>R  :set operatorfunc=ReflowComment<cr>g@
  vnoremap <leader>R  :<C-u>call ReflowComment(visualmode())<cr>

  nnoremap <BS>       <C-^>

  " ======= SAYONARA ==================
  map Q :Sayonara<CR> " delete buffer and close window
  map <leader>Q :Sayonara!<CR> " delete buffer and preserve window

  " ======= SNEAK =====================
  let g:sneak#label      = 1
  let g:sneak#use_ic_scs = 1
  let g:sneak#s_next = 1
  map f <Plug>Sneak_f
  map F <Plug>Sneak_F
  map t <Plug>Sneak_t
  map T <Plug>Sneak_T
  omap o <Plug>Sneak_s
  omap O <Plug>Sneak_S
  " 2-character Sneak (default)
  map <leader>j <Plug>Sneak_s
  map <leader>k <Plug>Sneak_S

  " ======= SAD =======================
  " Sad makes replacing selections easier and just automates some tedious
  " plumbing around slash search and cgn.
  map <leader>c <Plug>(sad-change-forward)
  map <leader>C <Plug>(sad-change-backward)

  " ======= EDITORCONFIG ==============
  let g:EditorConfig_max_line_indicator = "exceeding"
  let g:EditorConfig_preserve_formatoptions = 1

  " ======= MARKDOWN FOLDING ==========
  let g:markdown_fold_style = "nested"

  " ======= GUTENTAGS =================
  let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
  let g:gutentags_file_list_command = 'rg\ --files'

  " ======= FZF VIM ===================
  autocmd! FileType fzf set laststatus=0 noshowmode noruler
              \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fl :Lines<CR>
  nnoremap <leader>fh :BLines<CR>
  nnoremap <leader>fc :Commits<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fg :GFiles<CR>
  nnoremap <leader>fm :Marks<CR>
  nnoremap <leader>ft :Tags<CR>

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

  " ======= MATCHUP ===================
  " Otherwise the status line is overwritten with matching code parts
  let g:matchup_matchparen_offscreen = {}

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
      buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
      buf_set_keymap(bufnr, 'n', '<localleader>h',  '<cmd>lua vim.lsp.buf.signature_help()<CR>',               opts)
      buf_set_keymap(bufnr, 'n', '<localleader>re', '<cmd>lua vim.lsp.buf.rename()<CR>',                       opts)
      buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>lua vim.lsp.buf.references()<CR>',                   opts)
      buf_set_keymap(bufnr, 'n', '<localleader>ri', '<cmd>lua vim.lsp.buf.implementation()<CR>',               opts)
      buf_set_keymap(bufnr, 'n', '<localleader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>',                   opts)
      buf_set_keymap(bufnr, 'n', '<localleader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>',              opts)
      buf_set_keymap(bufnr, 'n', '<localleader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',                  opts)
      buf_set_keymap(bufnr, 'n', '<localleader>p',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
      buf_set_keymap(bufnr, 'n', '<localleader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>',             opts)
      buf_set_keymap(bufnr, 'n', '<localleader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>',              opts)
      buf_set_keymap(bufnr, 'n', '<localleader>dh', '<cmd>lua vim.lsp.buf.document_highlight()<CR>',           opts)
      buf_set_keymap(bufnr, 'n', '<localleader>sr', '<cmd>lua vim.lsp.buf.server_ready()<CR>',                 opts)
      buf_set_keymap(bufnr, 'n', '<C-j>',  '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',             opts)
      buf_set_keymap(bufnr, 'n', '<C-k>',  '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',             opts)
      buf_set_keymap(bufnr, 'n', '<localleader>l',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',           opts)
  end

  local configs = require'lspconfig/configs'

  nvim_lsp.util.default_config = vim.tbl_extend(
    "force",
    nvim_lsp.util.default_config,
    { on_attach = on_attach }
  )

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = false,
      update_in_insert = false,
    }
  )

  nvim_lsp.rust_analyzer.setup{}
  nvim_lsp.gopls.setup{}
  nvim_lsp.hls.setup{}
  nvim_lsp.dhall_lsp_server.setup{}
  EOF

  " ========= NVIM-TREESITTER =========
  packadd nvim-treesitter
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {},
    highlight = {
      enable = true,
      disable = {},
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-w>",
        node_decremental = "<A-w>",
      },
    },
    indent = {
      enable = true,
      disable = { "clojure" },
    }
  }
  EOF

  " ========= NVIM-COMPE ==============
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

  lua <<EOF
  require'compe'.setup {
    enabled = true;
    debug = true;
    autocomplete = true;
    preselect = 'always';
    min_length = 1;
    documentation = true;

    source = {
      buffer = true;
      path = true;
      nvim_lsp = true;
      tags = false;
      vsnip = false;
      conjure = true;
    };
  }
  EOF
''
