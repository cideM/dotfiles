{ pkgs, ... }:

{ lib, config, ... }:

# TODO: Use more plugins from nixpkgs, only use own source when not available
# or too old

with lib;
let
  initvim = ''
    if !exists("g:os")
        if has("win64") || has("win32") || has("win16")
            let g:os = "Windows"
        else
            let g:os = substitute(system("uname"), "\n", "", "")
        endif
    endif

    packadd nvim-lsp-latest
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
    set shell=${pkgs.bash}/bin/bash
    " https://www.reddit.com/r/vim/comments/25g1sp/why_doesnt_vim_syntax_like_my_shell_files/
    let g:is_posix = 1
    set wildignore+=*/.git/*,
                \tags,
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
    set list
    set listchars=tab:·\ ,extends:›,precedes:‹,nbsp:·,trail:·
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

    " MAPPINGS {{{
    command! FormatBuffer :normal msggVGgq`s

    " KEEP THIS AT THE TOP OF ALL MAPPINGS
    let mapleader = " "
    let maplocalleader = ","

    imap jk <Esc>

    nnoremap H ^
    vnoremap H ^
    nnoremap L g_
    vnoremap L g_

    nnoremap <leader>gg :lgrep<space>
    nnoremap <leader>gw :lgrep -wF \'\'<left>

    vmap Q <Plug>FormatVisual
    nmap Q <Plug>FormatMotion
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

    " fzf
    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    autocmd! FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    nnoremap <leader>f :Files<CR>
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>G :GFiles<CR>
    nnoremap <leader>m :Marks<CR>
    nnoremap <leader>t :Tags<CR>

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
    nmap gs <Plug>Sneak_s
    nmap gS <Plug>Sneak_S
    xmap gs <Plug>Sneak_s
    xmap gS <Plug>Sneak_S
    omap gs <Plug>Sneak_s
    omap gS <Plug>Sneak_S
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
    " }}}

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
    colorscheme space_vim_theme
  '';

  vimPluginsSources = import ./nix/sources.nix;

  conjure = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "conjure";
    version = "latest";
    src = vimPluginsSources.conjure;
  });

  nvim-lsp = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-lsp";
    version = "latest";
    src = vimPluginsSources.nvim-lsp;
  });

  vim-markdown-folding = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "vim-markdown-folding";
    version = "latest";
    src = vimPluginsSources.vim-markdown-folding;
  });

  parinfer-rust = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "parinfer";
    version = "latest";
    postInstall = ''
      rtpPath=$out/share/vim-plugins/${pname}-${version}
      mkdir -p $rtpPath/plugin
      sed "s,let s:libdir = .*,let s:libdir = '${pkgs.parinfer-rust}/lib'," \
        plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
    '';
    src = vimPluginsSources.parinfer;
  });

  onehalf = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "onehalf";
    version = "latest";
    src = "${vimPluginsSources.onehalf}/vim";
  });

  # TODO: I think this is rather silly. This should just be an attrs { css =
  # "vim script stuff" } so I can easily refer to drvs. Or properly sort out
  # buildInputs in case some of these have dependencies
  localPlugins =
    builtins.map
      (pkg: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = pkg;
        version = "latest";
        src = ./. + "/plugins" + ("/" + pkg);
      })
      [
        "clojure"
        "css"
        "dhall"
        "find-utils"
        "go"
        "haskell"
        "javascript"
        "jenkinsfile"
        "json"
        "lua"
        "make"
        "markdown"
        "nix"
        "reflow"
        "rust"
        "sh"
        "typescript"
        "vim"
        "syntax"
        "xml"
        "yaml"
        "zen"
      ];

  remotePlugins = with builtins;
    map
      (pkg:
        let
          repoName = elemAt (split ":" pkg.repo) 2;
        in
        pkgs.vimUtils.buildVimPluginFrom2Nix {
          # repo should have colon, so split at that and then get 2nd elements
          # git@github.com:foo/bar -> foo/bar
          pname = elemAt (split "/" repoName) 2;
          version = "latest";
          src = pkg;
        })
      [
        vimPluginsSources.Apprentice
        vimPluginsSources.vim-colortemplate
        vimPluginsSources.vim-cool
        vimPluginsSources.vim-matchup
        vimPluginsSources.vim-polyglot
        vimPluginsSources.vim-qf
        vimPluginsSources.spacevim
        vimPluginsSources.yui
        vimPluginsSources.sad
      ];

in
{
  config = {
    programs.neovim.enable = true;

    programs.neovim.configure = {
      # Remember to compare this to the init.vim in src every once in a while
      # to make sure both are synced.
      customRC = initvim;

      packages.clojure = {
        opt = [
          conjure
          parinfer-rust
        ];
      };

      packages.foobar = {
        start = [
          onehalf
          vim-markdown-folding
          pkgs.vimPlugins.fzfWrapper
          pkgs.vimPlugins.fzf-vim
          pkgs.vimPlugins.vim-sneak
          pkgs.vimPlugins.vim-unimpaired
          pkgs.vimPlugins.vim-fugitive
          pkgs.vimPlugins.vim-commentary
          pkgs.vimPlugins.vim-dirvish
          pkgs.vimPlugins.iceberg-vim
          pkgs.vimPlugins.targets-vim
          pkgs.vimPlugins.vim-eunuch
          pkgs.vimPlugins.editorconfig-vim
          pkgs.vimPlugins.vim-easy-align
          pkgs.vimPlugins.vim-gutentags
          pkgs.vimPlugins.vim-rhubarb
          pkgs.vimPlugins.vim-repeat
          pkgs.vimPlugins.vim-sandwich
          pkgs.vimPlugins.ale
          pkgs.vimPlugins.vim-indent-object
        ]
        ++ localPlugins
        ++ remotePlugins;

        opt = [
          nvim-lsp
        ];
      };
    };
  };
}
