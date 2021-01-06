{ config, lib, pkgs, ... }:
let
  cfg = config.programs.neovim;

  alacCfg = config.programs.alacritty;

  useAle = cfg.clojure.kondo.enable || cfg.ale.enable || cfg.haskell.hlint.enable;

  # These are my vanilla settings, which should form the foundation upon which
  # to buil my Neovim configuration. I should always try to make things work
  # with vanilla functionality or my own Lua scripts before reaching for
  # plugins.
  base = ''
    " ==============================
    " =       GENERAL SETTINGS     =
    " ==============================
    " Don't load the built-in plugin so that the custom 'matchup' plugin is the
    " only such plugin that is active.
    " This doesn't seem to work
    let g:loaded_matchit = 1

    set background=light
    set nocursorline
    set number
    set relativenumber
    set tabstop=4
    set list
    set formatoptions=tcrqjn
    set wildignore+=*/.git/*,
                \*/node_modules/*,
                \*/build/*,
                \*/dist/*,
                \*/compiled/*,
                \*/tmp/*
    set diffopt=algorithm:patience,filler,indent-heuristic,closeoff,iwhite
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set hidden
    set signcolumn=yes:3
    set ignorecase
    set number
    " TODO: Understand completetops
    set completeopt=menuone,noinsert,noselect
    set smartcase
    set inccommand=split
    set path-=/usr/include
    set splitbelow
    " I use Fish but it makes everything in Neovim a bit slower if it's used as
    " shell, especially Fugitive stuff
    set shell=bash
    set foldlevelstart=99
    set splitright
    set termguicolors
    set undofile
    ${if cfg.completion.preview.enable then ''
      set completeopt+=preview
    '' else ''
      set completeopt-=preview
    ''}

    " ==============================
    " =        COLORSCHEME         =
    " ==============================
    augroup my_neomake_highlights
        au!
        autocmd ColorScheme *
          \ highlight link SneakScope IncSearch
    augroup END
    let g:yui_comments = "emphasize"
    let g:tokyonight_enable_italic = 1
    let g:tokyonight_style = 'storm'
    colorscheme ${if alacCfg.light then "yui" else "tokyonight"}

    " https://github.com/neovim/neovim/issues/13113
    augroup Foo
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
    nnoremap <leader>T  :split <Bar> lcd %:p:h <Bar> term fish<CR>

    " Leave insert mode with jk
    imap jk             <Esc>

    nmap <leader>s :w<CR>

    " Convenience mappings for calling :grep
    nnoremap <leader>gg :grep!<space>
    nnoremap <leader>gw :grep! -wF ""<left>

    " Just calls formatprg on entire buffer
    nmap     <leader>Q  :call FormatBuffer()<cr>

    nnoremap <leader>f  :find *
    nnoremap <leader>b  :ls<cr>:buffer<Space>

    vmap     <Enter>    <Plug>(EasyAlign)

    nnoremap <leader>s  :nohlsearch<CR>

    " Reflow comments according to max line length. This temporarily unsets
    " formatprg so cindent (?) is used. I don't know... this mostly just works.
    nnoremap <leader>R  :set operatorfunc=reflow#Comment<cr>g@
    vnoremap <leader>R  :<C-u>call reflow#Comment(visualmode())<cr>

    " Switch to alternate buffer with backspace
    nnoremap <BS>       <C-^>
  '';

  editorconfig = ''
    " ======= EDITORCONFIG ==============
    let g:EditorConfig_max_line_indicator = "exceeding"
    let g:EditorConfig_preserve_formatoptions = 1
  '';

  markdown-folding = ''
    " ======= MARKDOWN FOLDING ==========
    let g:markdown_fold_style = "nested"
  '';

  colorizer = ''
    " ======= NVIM COLORIZER ============
    packadd nvim-colorizer
    lua require'colorizer'.setup()
  '';

  gutentags = ''
    " ======= GUTENTAGS =================
    " No ctags for Haskell
    let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
    let g:gutentags_file_list_command = 'rg\ --files'
  '';

  matchup = ''
    " ======= MATCHUP ===================
    " Otherwise the status line is overwritten with matching code parts
    let g:matchup_matchparen_offscreen = {}
  '';

  sad = ''
    " ======= SAD =======================
    " Sad makes replacing selections easier and just automates some tedious
    " plumbing around slash search and cgn.
    map <leader>c <Plug>(sad-change-forward)
    map <leader>C <Plug>(sad-change-backward)
  '';

  asterisk = ''
    " ======= ASTERISK ==================
    " This should override the mappings for * and # which are provided by sad.
    " Use stay motions per default, meaning pressing * won't jump to the first
    " match.
    map *  <Plug>(asterisk-z*)
    map #  <Plug>(asterisk-z#)
    map g* <Plug>(asterisk-gz*)
    map g# <Plug>(asterisk-gz#)
  '';

  sneak = ''
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
  '';

  lsp = ''
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
        buf_set_keymap(bufnr, 'n', '<localleader>K',  '<cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
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
        buf_set_keymap(bufnr, 'n', '<localleader>j',  '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',             opts)
        buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',             opts)
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
        signs = true,
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

    nvim_lsp.rust_analyzer.setup{}
    nvim_lsp.gopls.setup{}
    nvim_lsp.hls.setup{}
    nvim_lsp.dhall.setup{}
    EOF
  '';

  ale = ''
    " ========= ALE =====================
    nmap <localleader>ad <Plug>(ale_detail)
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
    nmap <silent> <localleader>af <Plug>(ale_fix)
  '';

  treesitter = ''
    " ========= NVIM-TREESITTER =========
    packadd nvim-treesitter
    lua <<EOF
    require'nvim-treesitter.configs'.setup {
      ensure_installed = {},
      highlight = {
        enable = true,
        disable = {},
      },
    }
    EOF
  '';

  telescope = ''
    " ======= TELESCOPE =================
    packadd telescope
    lua <<EOF
    require('telescope').setup{
      defaults = {
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
      }
    }
    EOF
    nnoremap ${cfg.telescope.prefix}p  <cmd>Telescope find_files<cr>
    nnoremap ${cfg.telescope.prefix}b  <cmd>Telescope buffers<cr>
    nnoremap ${cfg.telescope.prefix}g  <cmd>Telescope live_grep<cr>
    nnoremap ${cfg.telescope.prefix}D  <cmd>Telescope lsp_document_symbols<cr>
    nnoremap ${cfg.telescope.prefix}W  <cmd>Telescope lsp_workspace_symbols<cr>
    nnoremap ${cfg.telescope.prefix}m  <cmd>Telescope marks<cr>
    nnoremap ${cfg.telescope.prefix}f  <cmd>Telescope git_files<cr>
    nnoremap ${cfg.telescope.prefix}l  <cmd>Telescope current_buffer_fuzzy_find<cr>
    nnoremap ${cfg.telescope.prefix}w  <cmd>Telescope grep_string<cr>
    nnoremap ${cfg.telescope.prefix}p  <cmd>Telescope builtin<cr>
    nnoremap ${cfg.telescope.prefix}a  <cmd>Telescope tags<cr>
    nnoremap ${cfg.telescope.prefix}t  <cmd>Telescope current_buffer_tags<cr>
  '';

  deoplete = ''
    " ======= DEOPLETE ==================
    " If using Deoplete as default completion provider, load it right away and
    " enable it
    let g:deoplete#enable_at_startup = 1
    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    let g:completion_auto_change_source = 1
    packadd deoplete-nvim
    packadd deoplete-lsp
    autocmd! deoplete#lsp
  '';

  float-preview = ''
    " ======= FLOAT-PREVIEW =============
    let g:float_preview#docked = 1
    set completeopt-=preview
  '';

  completion-nvim = ''
    " ======= COMPLETION ================
    set completeopt=menuone,noinsert,noselect

    " Load on-demand when not using LSP
    let g:deoplete#enable_at_startup = 0
    let g:float_preview#docked = 1
    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    let g:completion_auto_change_source = 1
    " Hover windows have problems with long paths
    " https://github.com/nvim-lua/completion-nvim/issues/305
    let g:completion_enable_auto_hover = 0

    function! MaybeActivateCompletion()
        " Some languages work better with deoplete
        if exists('b:no_completion_nvim')
            return
        endif
        " Disable Deoplete again if runnig
        try
          call deoplete#disable()
        catch
        endtry
        lua require'completion'.on_attach()
    endfunction

    " Activate it for all buffers for buffer, tag and path completion
    " except if disabled so e.g., Deoplete can take over
    autocmd BufEnter * call MaybeActivateCompletion()
    imap  <c-j> <Plug>(completion_next_source)
    imap  <c-k> <Plug>(completion_prev_source)
    let g:completion_chain_complete_list = {
        \'default': [
        \   {'complete_items': ['lsp']},
        \   {'complete_items': ['buffers']},
        \   {'mode': '<c-p>'},
        \   {'mode': '<c-n>'},
        \   {'complete_items': ['tags']},
        \   {'complete_items': ['path']},
        \]
        \}
  '';
in
base
+ editorconfig
+ markdown-folding
+ gutentags
# TODO: This has a conflict with surround
+ matchup
+ sad
+ (if cfg.editor.asterisk then asterisk else "")
+ (if cfg.editor.colorizer then colorizer else "")
+ (if cfg.editor.sneak then sneak else "")
+ (if cfg.editor.sad then sad else "")
+ (if cfg.lsp.enable && cfg.lsp.backend == "nvim-lsp" then lsp else "")
+ (if useAle then ale else "")
+ (if cfg.treesitter.enable then treesitter else "")
+ (if cfg.telescope.enable then telescope else "")
+ (if cfg.completion.enable && cfg.completion.backend == "deoplete" then deoplete else "")
+ (if cfg.completion.float-preview-nvim.enable then float-preview else "")
  + (if cfg.completion.enable && cfg.completion.backend == "completion-nvim" then completion-nvim else "")
