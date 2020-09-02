{ pkgs, ... }:

{ lib, config, ... }:

with lib;
with builtins;
let
  init = ''
    if !exists("g:os")
        if has("win64") || has("win32") || has("win16")
            let g:os = "Windows"
        else
            let g:os = substitute(system('uname'), '\n', "", "")
        endif
    endif

    " LSP {{{
    packadd nvim-lsp

    lua << EOF
    local nvim_lsp = require('nvim_lsp')
    local buf_set_keymap = vim.api.nvim_buf_set_keymap

    local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }
        buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<localleader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<localleader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '[I',             '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap(bufnr, 'n', ']I',             '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<localleader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<localleader>t', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<localleader>T', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<localleader>D', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
    end

    local configs = require'nvim_lsp/configs'

    configs.dhall = {
        default_config = {
                cmd = {'${pkgs.haskellPackages.dhall-lsp-server}/bin/dhall-lsp-server'};
                filetypes = {'dhall'};
                root_dir = function(fname)
                    return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
                end;
                settings = {};
        };
    }

    local servers = {'gopls', 'rust_analyzer', 'dhall', 'purescriptls'}

    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup { on_attach = on_attach }
    end

    vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
    EOF

    " SETTINGS {{{
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
    set grepprg=${pkgs.ripgrep}/bin/rg\ --vimgrep\ --no-heading\ --smart-case
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
    set completeopt-=preview
    set completeopt+=noinsert
    set path-=/usr/include
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
    " }}}

    augroup SetPath
        autocmd!
        autocmd VimEnter * call pathutils#SetPath()
    augroup END

    " MAPPINGS {{{
    function! FormatBuffer()
      let view = winsaveview()
      normal ggVGgq
      call winrestview(view)
    endfunction

    let g:EditorConfig_max_line_indicator = "exceeding"

    " KEEP THIS AT THE TOP OF ALL MAPPINGS
    let mapleader = " "
    let maplocalleader = ","

    imap jk <Esc>

    nnoremap H ^
    vnoremap H ^
    nnoremap L g_
    vnoremap L g_

    nnoremap <leader>gg :grep<space>
    nnoremap <leader>gw :grep -wF ""<left>

    nmap <leader>Q :call FormatBuffer()<cr>

    nnoremap <leader>f :find *
    nnoremap <leader>b :buffer *
    nnoremap <leader>tt :ts *
    nnoremap <leader>ts :sts *
    nnoremap <leader>gb :ls<cr>:buffer<Space>

    nnoremap <leader>vt :tabnew <Bar> Gedit :<cr>

    vmap     <Enter>    <Plug>(EasyAlign)

    " asterisk
      map *   <Plug>(asterisk-*)
      map #   <Plug>(asterisk-#)
      map g*  <Plug>(asterisk-g*)
      map g#  <Plug>(asterisk-g#)
      map z*  <Plug>(asterisk-z*)
      map gz* <Plug>(asterisk-gz*)
      map z#  <Plug>(asterisk-z#)
      map gz# <Plug>(asterisk-gz#)

    " Fern
      " Drawer style, does not have opener
      nmap <leader>ee :Fern . -drawer<CR>
      " Current file
      nmap <leader>eh :Fern %:h<CR>
      " Focus Fern
      nmap <leader>ef :FernDo :<CR>
      nmap <leader>el <Plug>(fern-action-leave)
      nmap <leader>eo <Plug>(fern-action-open:select)

    nnoremap <leader>R :set operatorfunc=reflow#Comment<cr>g@
    vnoremap <leader>R :<C-u>call reflow#Comment(visualmode())<cr>

    nnoremap <BS> <C-^>

    " Neovim Terminal
    " http://vimcasts.org/episodes/neovim-terminal-mappings/
    tnoremap <Esc> <C-\><C-n>
    tnoremap <M-[> <Esc>
    tnoremap <C-v><Esc> <Esc>
    " }}}

    " sad
    nmap <leader>c <Plug>(sad-change-forward)
    nmap <leader>C <Plug>(sad-change-backward)
    xmap <leader>c <Plug>(sad-change-forward)
    xmap <leader>C <Plug>(sad-change-backward)

    " andymass/vim-matchup
    let g:matchup_matchparen_offscreen = {}

    let g:gutentags_exclude_filetypes = ['haskell']
    let g:gutentags_file_list_command = '${pkgs.ripgrep}/bin/rg\ --files'

    " romainl/vim-qf
    let g:qf_auto_open_loclist = 1
    nmap <leader>qq <Plug>QfCtoggle
    nmap <leader>ll <Plug>QfLtoggle

    " sandwich
    let g:sandwich_no_default_key_mappings = 1
    silent! nmap <unique><silent> gk <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> gr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> gkb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
    silent! nmap <unique><silent> grb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

    let g:operator_sandwich_no_default_key_mappings = 1
    " add
    silent! map <unique> ga <Plug>(operator-sandwich-add)
    " delete
    silent! xmap <unique> gd <Plug>(operator-sandwich-delete)
    " replace
    silent! xmap <unique> gr <Plug>(operator-sandwich-replace)

    " vim-sneak
    let g:sneak#label      = 1
    let g:sneak#use_ic_scs = 1
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
    " }}}

    nnoremap <leader>u :MundoToggle<CR>

    " STATUSLINE {{{
    set statusline=
    set statusline+=\ %f
    set statusline+=\ %m 
    set statusline+=\%{FugitiveStatusline()} 
    set statusline+=\ %{mode()}\ 
    set statusline+=%=
    set statusline+=\%{gutentags#statusline('[',']\ ')}
    set statusline+=%y\ " buffer type
    set statusline+=%q\ 
    set statusline+=%3l:%2c\ \|
    set statusline+=%3p%%\ 
    " }}}

    let g:one_allow_italics = 1
    let g:yui_comments = "emphasize"
    colorscheme iceberg
  '';

  ftPluginDir = toString ./ftplugin;

  # For ./. see https://github.com/NixOS/nix/issues/1074 otherwise it's not an
  # absolute path
  readFtplugin = name: builtins.readFile ("${ftPluginDir}/${name}.vim");

  plugins = (import ./plugins.nix { inherit pkgs; });

  localPlugins =
    builtins.map
      (pkg: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = pkg;
        version = "latest";
        src = ./. + "/plugins" + ("/" + pkg);
      })
      [
        "find-utils"
        "path-utils"
        "reflow"
        "syntax"
        "zen"
      ];

in
{
  config = {
    programs.neovim.enable = true;

    # TODO: Should just add all automatically
    programs.neovim.ftPlugins =
      trivial.pipe
        [
          "css"
          "clojure"
          "dhall"
          "go"
          "haskell"
          "javascript"
          "Jenkinsfile"
          "json"
          "lua"
          "make"
          "purescript"
          "markdown"
          "rust"
          "sh"
          "nix"
          "typescript"
          "vim"
          "xml"
          "yaml"
        ]
        [ (builtins.map (name: attrsets.nameValuePair name (readFtplugin name))) (builtins.listToAttrs) ];

    programs.neovim.configure = {
      customRC = init;

      packages.foobar = {
        start = [
          pkgs.vimPlugins.editorconfig-vim
          pkgs.vimPlugins.targets-vim
          pkgs.vimPlugins.vim-commentary
          pkgs.vimPlugins.vim-dirvish
          pkgs.vimPlugins.vim-easy-align
          pkgs.vimPlugins.vim-eunuch
          pkgs.vimPlugins.vim-gutentags
          pkgs.vimPlugins.vim-indent-object
          pkgs.vimPlugins.vim-repeat
          pkgs.vimPlugins.vim-sandwich
          pkgs.vimPlugins.vim-asterisk
          pkgs.vimPlugins.vim-sneak
          pkgs.vimPlugins.vim-unimpaired
          pkgs.vimPlugins.vim-peekaboo
          pkgs.vimPlugins.limelight-vim
          pkgs.vimPlugins.vim-mundo
          plugins.sad
          plugins.vim-scratch
          plugins.vim-colortemplate
          plugins.vim-cool
          plugins.vim-visual-split
          plugins.vim-matchup
          plugins.vim-qf
          plugins.fern

          # Git
          pkgs.vimPlugins.vim-fugitive
          pkgs.vimPlugins.vim-rhubarb

          # Language Tooling
          plugins.parinfer-rust
          plugins.vim-markdown-folding
          plugins.conjure

          # Themes
          plugins.onehalf
          plugins.apprentice
          pkgs.vimPlugins.iceberg-vim
          pkgs.vimPlugins.papercolor-theme
          plugins.yui
          plugins.spacevim

          # Languages
          pkgs.vimPlugins.purescript-vim
          pkgs.vimPlugins.vim-nix
          pkgs.vimPlugins.dhall-vim
          plugins.vim-js
          pkgs.vimPlugins.yats-vim
          pkgs.vimPlugins.vim-jsx-pretty
        ]
        ++ localPlugins;

        opt = [
          plugins.nvim-lsp
        ];
      };
    };
  };
}
