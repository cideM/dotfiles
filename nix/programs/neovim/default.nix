{ pkgs, ... }:

{ lib, config, ... }:

with lib;
with builtins;

let
  init = ''
    " Fix an issue with polyglot and dhall ft
    augroup dhall
    augroup END

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

    local servers = {'gopls', 'rust_analyzer', 'dhall'}

    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup { on_attach = on_attach }
    end

    -- disable diagnostics since I use Ale for this
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
    set ignorecase
    set noshowmode
    set updatetime=100
    set nolist
    " set listchars=tab:·\ ,extends:›,precedes:‹,nbsp:·,trail:·
    set inccommand=split
    set nocursorline
    set nonumber
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

    let g:rainbow_active = 1

    " MAPPINGS {{{
    command! FormatBuffer :normal msggVGgq`s

    " KEEP THIS AT THE TOP OF ALL MAPPINGS
    let mapleader = " "
    let maplocalleader = ","

    imap jk <Esc>

    " asterisk
    map *   <Plug>(asterisk-*)
    map #   <Plug>(asterisk-#)
    map g*  <Plug>(asterisk-g*)
    map g#  <Plug>(asterisk-g#)
    map z*  <Plug>(asterisk-z*)
    map gz* <Plug>(asterisk-gz*)
    map z#  <Plug>(asterisk-z#)
    map gz# <Plug>(asterisk-gz#)

    " Drawer style, does not have opener
    nmap <leader>ee :Fern . -drawer<CR>
    " Current file
    nmap <leader>eh :Fern %:h<CR>
    " Focus Fern
    nmap <leader>ef :FernDo :<CR>

    nnoremap H ^
    vnoremap H ^
    nnoremap L g_
    vnoremap L g_

    " deoplete and friends
    let g:deoplete#enable_at_startup = 1
    " https://github.com/Shougo/deoplete.nvim/issues/1105
    let g:neosnippet#enable_completed_snippet = 1
    let g:neosnippet#enable_complete_done = 1

    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    "imap <expr><TAB>
    " \ pumvisible() ? "\<C-n>" :
    " \ neosnippet#expandable_or_jumpable() ?
    " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    " For conceal markers.
    if has('conceal')
        set conceallevel=2 concealcursor=niv
    endif

    nnoremap <leader>gg :grep<space>
    nnoremap <leader>gw :grep -wF ""<left>

    nmap <leader>Q :FormatBuffer<cr>

    vmap     <Enter>    <Plug>(EasyAlign)

    nnoremap <leader>R :set operatorfunc=reflow#Comment<cr>g@
    vnoremap <leader>R :<C-u>call reflow#Comment(visualmode())<cr>

    nnoremap <BS> <C-^>

    " Neovim Terminal
    " http://vimcasts.org/episodes/neovim-terminal-mappings/
    tnoremap <Esc> <C-\><C-n>
    tnoremap <M-[> <Esc>
    tnoremap <C-v><Esc> <Esc>
    " }}}

    " PLUGINS {{{
    " ale
    let g:ale_sign_column_always = 1
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_fix_on_save = 1
    let g:ale_go_golangci_lint_options = 'fast'
    nmap <leader>ad <Plug>(ale_detail)
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
    nmap <silent> <C-f> <Plug>(ale_fix)

    " sad
    nmap <leader>c <Plug>(sad-change-forward)
    nmap <leader>C <Plug>(sad-change-backward)
    xmap <leader>c <Plug>(sad-change-forward)
    xmap <leader>C <Plug>(sad-change-backward)

    " andymass/vim-matchup
    let g:matchup_matchparen_offscreen = {}
    let g:polyglot_disabled = ['latex', 'markdown', 'fish']
    let g:gutentags_exclude_filetypes = ['haskell']

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

    " fzf
    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    autocmd! FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    nnoremap <leader>f :Files<CR>
    nnoremap <leader>F :GFiles<CR>
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>m :Marks<CR>
    nnoremap <leader>t :Tags<CR>

    " Open full screen fugitive status in new tab
    command! -bar GitStatusTab execute 'tabnew | Gedit :'
    nnoremap <leader>Gt :GitStatusTab<cr>

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

    " vim-sneak
    let g:sneak#label      = 1
    let g:sneak#use_ic_scs = 1
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
    " }}}

    let g:undotree_WindowLayout = 2
    nnoremap U :UndotreeToggle<CR>

    " STATUSLINE {{{
    set statusline=
    set statusline+=\ %t
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
    colorscheme space_vim_theme
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
        "reflow"
        "syntax"
        "zen"
      ];

in
{
  config = {
    programs.neovim.enable = true;

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
          pkgs.vimPlugins.ale
          pkgs.vimPlugins.vim-asterisk
          pkgs.vimPlugins.deoplete-lsp
          pkgs.vimPlugins.deoplete-nvim
          pkgs.vimPlugins.editorconfig-vim
          pkgs.vimPlugins.fzf-vim
          pkgs.vimPlugins.fzfWrapper
          pkgs.vimPlugins.iceberg-vim
          pkgs.vimPlugins.neosnippet-snippets
          pkgs.vimPlugins.neosnippet-vim
          pkgs.vimPlugins.targets-vim
          pkgs.vimPlugins.vim-commentary
          pkgs.vimPlugins.vim-dirvish
          pkgs.vimPlugins.vim-easy-align
          pkgs.vimPlugins.vim-eunuch
          pkgs.vimPlugins.vim-fugitive
          pkgs.vimPlugins.vim-gutentags
          pkgs.vimPlugins.vim-indent-object
          pkgs.vimPlugins.vim-repeat
          pkgs.vimPlugins.vim-rhubarb
          pkgs.vimPlugins.vim-sandwich
          pkgs.vimPlugins.vim-sneak
          pkgs.vimPlugins.vim-signify
          pkgs.vimPlugins.undotree
          pkgs.vimPlugins.rainbow
          pkgs.vimPlugins.vim-snippets
          pkgs.vimPlugins.vim-unimpaired
          pkgs.vimPlugins.vim-peekaboo
          pkgs.vimPlugins.limelight-vim
          pkgs.vimPlugins.git-messenger-vim
          plugins.gina
          plugins.vim-markdown-toc
          plugins.fern
          plugins.sad
          plugins.yui
          plugins.spacevim
          plugins.edge-theme
          plugins.conjure
          plugins.vim-markdown-folding
          plugins.parinfer-rust
          plugins.onehalf
          plugins.apprentice
          plugins.vim-colortemplate
          plugins.vim-cool
          plugins.vim-matchup
          plugins.vim-polyglot
          plugins.vim-qf
        ]
        ++ localPlugins;

        opt = [
          plugins.nvim-lsp
        ];
      };
    };
  };
}
