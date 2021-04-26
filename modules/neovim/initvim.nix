{ config, lib, pkgs, ... }:
let
  cfg = config.programs.neovim;

  feline = builtins.readFile ./feline.lua;

in
''
  " ==============================
  " =       GENERAL SETTINGS     =
  " ==============================
  " Don't load the built-in plugin so that the custom 'matchup' plugin is the
  " only such plugin that is active.
  " This doesn't seem to work
  let g:loaded_matchit = 1

  function! LspStatus() abort
      if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('lsp-status').status()")
      endif

      return ""
  endfunction

  set background=light
  set foldmethod=indent
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
  set autoindent
  set number
  set signcolumn=yes:2
  set ignorecase
  set completeopt=menuone,noselect,noinsert
  set smartcase
  set inccommand=split
  set path-=/usr/include
  set splitbelow
  set foldlevelstart=99
  set splitright
  set list
  set listchars=lead:\ ,tab:>\ ,trail:¬
  set termguicolors
  set undofile
  " Need to look into this properly
  " set statusline=
  " set statusline+=\ %f
  " set statusline+=\ %m
  " set statusline+=%{get(b:,'gitsigns_status',\'\')}
  " set statusline+=\ %{get(b:,'gitsigns_head',\'\')}
  " set statusline+=\ %{mode()}\ 
  " set statusline+=%=
  " set statusline+=%{LspStatus()}
  " set statusline+=%y\ " buffer type
  " set statusline+=%q\ 
  " set statusline+=%3l:%2c\ \|
  " set statusline+=%3p%%\ 

  let g:yui_comments = 'bg'
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

  " nnoremap <leader>T  :split <Bar> lcd %:p:h <Bar> term fish<CR>
  " nnoremap <leader>t  :split <Bar> term fish<CR>

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

  " ======= nvim-hlslens ==============
  noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
              \<Cmd>lua require('hlslens').start()<CR>
  noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
              \<Cmd>lua require('hlslens').start()<CR>
  vmap * <Plug>(sad-search-forward)<Cmd>lua require('hlslens').start()<CR>
  vmap # <Plug>(sad-search-backward)<Cmd>lua require('hlslens').start()<CR>
  nnoremap * *<Cmd>lua require('hlslens').start()<CR>
  nnoremap # #<Cmd>lua require('hlslens').start()<CR>
  noremap g* g*<Cmd>lua require('hlslens').start()<CR>
  noremap g# g#<Cmd>lua require('hlslens').start()<CR>

  " ======= Indent Blankline ==========
  let g:indent_blankline_char = '│'
  lua <<EOF
  vim.g.indent_blankline_show_current_context = false
  vim.g.indent_blankline_context_patterns = {'class', 'function', 'method', 'if', 'while', 'for'}
  EOF

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

  " ======= vim_current_word ==========
  let g:vim_current_word#highlight_current_word = 0

  " ======= EDITORCONFIG ==============
  let g:EditorConfig_max_line_indicator = "exceeding"
  let g:EditorConfig_preserve_formatoptions = 1

  " ======= MARKDOWN FOLDING ==========
  let g:markdown_fold_style = "nested"

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

  " ======= SAD =======================
  " Sad makes replacing selections easier and just automates some tedious
  " plumbing around slash search and cgn.
  map <leader>c <Plug>(sad-change-forward)
  map <leader>C <Plug>(sad-change-backward)

  " ======= GUTENTAGS =================
  let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
  let g:gutentags_file_list_command = 'rg\ --files'

  " ======= MATCHUP ===================
  " Otherwise the status line is overwritten with matching code parts
  let g:matchup_matchparen_offscreen = {}

  " ========= NVIM-LSP ================
  " https://neovim.io/doc/user/lsp.html

  command! -bar -nargs=0 RestartLSP :lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd("edit")

  packadd nvim-lsp
  lua <<EOF
  local lsp_status = require('lsp-status')
  local nvim_lsp = require'lspconfig'
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local api = vim.api

  local on_attach = function(client, bufnr)
      api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      local opts = { noremap=true, silent=true }
      buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua                  vim.lsp.buf.hover()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>h',  '<cmd>lua         vim.lsp.buf.signature_help()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>re', '<cmd>lua                 vim.lsp.buf.rename()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>lua             vim.lsp.buf.references()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>ri', '<cmd>lua         vim.lsp.buf.implementation()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>gd', '<cmd>lua             vim.lsp.buf.definition()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>gt', '<cmd>lua        vim.lsp.buf.type_definition()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>gD', '<cmd>lua            vim.lsp.buf.declaration()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>p',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>',           opts)
      buf_set_keymap(bufnr, 'n', '<localleader>ws', '<cmd>lua       vim.lsp.buf.workspace_symbol()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>ds', '<cmd>lua        vim.lsp.buf.document_symbol()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>dh', '<cmd>lua     vim.lsp.buf.document_highlight()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<localleader>sr', '<cmd>lua           vim.lsp.buf.server_ready()<CR>',                                      opts)
      buf_set_keymap(bufnr, 'n', '<C-j>',  '<cmd>lua                vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>', opts)
      buf_set_keymap(bufnr, 'n', '<C-k>',  '<cmd>lua                vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>', opts)
      buf_set_keymap(bufnr, 'n', '<localleader>l',  '<cmd>lua     vim.lsp.diagnostic.set_loclist()<CR>',                                      opts)

      lsp_status.on_attach(client)
  end

  local configs = require'lspconfig/configs'

  nvim_lsp.util.default_config = vim.tbl_extend(
    "force",
    nvim_lsp.util.default_config,
    { on_attach = on_attach }
  )

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
    })

  lsp_status.register_progress()
  lsp_status.config({
    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'i',
    indicator_hint = '?',
    indicator_ok = 'Ok',
  })

  nvim_lsp.rust_analyzer.setup{
      on_attach = on_attach,
      capabilities = lsp_status.capabilities
  }
  -- https://github.com/neovim/neovim/issues/13829
  -- nvim_lsp.purescriptls.setup{}
  nvim_lsp.gopls.setup{
      on_attach = on_attach,
      capabilities = lsp_status.capabilities
  }
  nvim_lsp.hls.setup{
      on_attach = on_attach,
      capabilities = lsp_status.capabilities
  }
  nvim_lsp.dhall_lsp_server.setup{}
  EOF

  " ======= Autopairs ================
  lua <<EOF
  require('nvim-autopairs').setup()
  EOF

  " ======= VIMTEX ====================
  let g:tex_flavor = 'latex'
  let g:vimtex_view_method = 'zathura'
  nnoremap <localleader>lt :call vimtex#fzf#run()<cr>

  " ======= FERN ======================
  " Drawer style, does not have opener
  nmap <leader>ee :Fern . -drawer<CR>
  " Current file
  nmap <leader>eh :Fern %:h -drawer<CR>
  " Focus Fern
  nmap <leader>ef :FernDo :<CR>
  nmap <leader>el <Plug>(fern-action-leave)
  nmap <leader>eo <Plug>(fern-action-open:select)

  " ========= NVIM-TREESITTER =========
  packadd nvim-treesitter
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {},
    highlight = {
      enable = true,
      disable = {'nix'},
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
      enable = false,
    }
  }
  EOF

  lua <<EOF
  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
  }
  EOF

  " ========= nvim-toggleterm.lua =====
  lua <<EOF
  require"toggleterm".setup{
    shading_factor = 0.1,
    size = 25,
    hide_numbers = true,
    open_mapping = [[<A-t>]],
  }
  EOF

  " ========= nvim-lspfuzzy ===========
  lua require('lspfuzzy').setup {}

  " ======= deoplete.nvim =============
  " Needed to call options function
  packadd deoplete-nvim
  call deoplete#custom#option('num_processes', 4)
  call deoplete#custom#option('refresh_always', v:false)
  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  call deoplete#enable()
  call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})

  " ========= NVIM-COMPE ==============
  " inoremap <silent><expr> <C-Space> compe#complete()
  " inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  " inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  " inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  " inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

  " https://github.com/hrsh7th/nvim-compe/issues/347
  " lua <<EOF
  " require'compe'.setup {
  "   enabled = true,
  "   default_pattern = '\d\@!\k\k*',
  "   debug = true,
  "   autocomplete = true,
  "   preselect = 'enable',
  "   min_length = 3,
  "   documentation = true,

  "   source = {
  "     buffer = {
  "       priority = 100,
  "     },
  "     conjure = {
  "       priority = 90,
  "     },
  "     nvim_lsp = {
  "       priority = 80,
  "     },
  "     path = {
  "       priority = 70,
  "     },
  "     tags = {
  "       priority = 0,
  "     },
  "     vsnip = false,
  "   },
  " }
  " EOF

  lua <<EOF
  ${feline}
  EOF
''
