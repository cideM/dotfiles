args@{ config
, lib
, pkgs
, lspfuzzy
, indent-blankline
, sad
, yui
, ...
}:

with lib;
with types;
let
  makeGrammar =
    { includedFiles
    , parserName
    , src
    , name ? parserName
    , version ? "latest"
    }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      version = version;
      name = "nvim-treesitter-${name}";
      src = src;
      buildPhase = ''
        runHook preBuild
        mkdir -p parser/
        ${pkgs.gcc}/bin/gcc -o parser/${parserName}.so -I$src/ ${builtins.concatStringsSep " " includedFiles}  -shared  -Os -lstdc++ -fPIC
        runHook postBuild
      '';
    };

  installFromBuiltGrammars = { src, parserFileName }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      version = "latest";
      dontUnpack = true;
      name = "nvim-treesitter-${parserFileName}";
      src = src;
      buildPhase = ''
        mkdir -p parser/
        cp $src parser/${parserFileName}.so
      '';
    };

  # TODO: Add all from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
  # TODO: Add them to nixpkgs once I've figured out how
  # https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lockfile.json
  grammarNix = makeGrammar {
    parserName = "nix";
    includedFiles = [ "parser.c" "scanner.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/cstrahan/tree-sitter-nix";
      "ref" = "master";
      "rev" = "d5287aac195ab06da4fe64ccf93a76ce7c918445";
      }}/src";
  };

  grammarClojure = makeGrammar {
    parserName = "clojure";
    includedFiles = [ "parser.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/sogaiu/tree-sitter-clojure";
      "ref" = "master";
      "rev" = "f7d100c4fbaa8aad537e80c7974c470c7fb6aeda";
      }}/src";
  };

  grammarYaml = makeGrammar {
    parserName = "yaml";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = "6129a83eeec7d6070b1c0567ec7ce3509ead607c";
      }}/src";
  };

  grammarGo = makeGrammar {
    includedFiles = [ "parser.c" ];
    parserName = "go";
    src = "${builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = "2a2fbf271ad6b864202f97101a2809009957535e";
      }}/src";
  };

  grammarJson = installFromBuiltGrammars {
    parserFileName = "json";
    src = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  };

  grammarHaskell = makeGrammar {
    includedFiles = [ "parser.c" "scanner.cc" ];
    parserName = "haskell";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://github.com/tree-sitter/tree-sitter-haskell";
      "rev" = "2e33ffa3313830faa325fe25ebc3769896b3a68b";
      }}/src";
  };

  grammarPython = makeGrammar {
    parserName = "python";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/tree-sitter/tree-sitter-python";
      "ref" = "master";
      "rev" = "d6210ceab11e8d812d4ab59c07c81458ec6e5184";
      }}/src";
  };

  grammarJavascript = makeGrammar {
    parserName = "javascript";
    includedFiles = [ "parser.c" "scanner.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/tree-sitter/tree-sitter-javascript";
      "ref" = "master";
      "rev" = "a263a8f53266f8f0e47e21598e488f0ef365a085";
      }}/src";
  };

  grammarTs = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "typescript";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "d0c785782a4384034d4a6460b908141a88ad7229";
      }}/typescript/src";
  };

  grammarTsx = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "tsx";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "d0c785782a4384034d4a6460b908141a88ad7229";
    }}/tsx/src";
  };
  cfg = config.programs.neovim;

  sources = config.sources;

  makeFtPlugins = ftplugins: with attrsets;
    mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" ({ text = value; }))
      ftplugins;
in
{
  config = {
    xdg.configFile = makeFtPlugins {
      xml = ''
        setl formatprg=prettier\ --stdin-filepath\ %";
      '';
      sh = ''
        setl formatprg=shfmt makeprg=shellcheck\ -f\ gcc\ %
        nnoremap <buffer> <localleader>m :silent make<cr>
      '';
      rust = ''
        setl formatprg=rustfmt
        setl makeprg=cargo\ check
      '';
      purescript = ''
        setl formatprg=purty\ format
        nnoremap <buffer> <localleader>t :!spago\ docs\ --format\ ctags
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      fzf = ''
        setl laststatus=0 noshowmode noruler
        aug fzf | au! BufLeave <buffer> set laststatus=2 showmode ruler | aug END
      '';
      qf = ''
        nnoremap <buffer> <left> :colder<cr>
        nnoremap <buffer> <right> :cnewer<cr>
      '';
      clojure = ''
        packadd conjure
        packadd parinfer
        setl errorformat=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
        setl makeprg=clj-kondo\ --lint\ %
        setl wildignore+=*.clj-kondo*
      '';
      javascript = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        nnoremap <buffer> <silent> <localleader>f :!${pkgs.nodePackages.eslint}/bin/eslint\ --fix\ %<cr>
      '';
      typescript = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        nnoremap <buffer> <silent> <localleader>f :!${pkgs.nodePackages.eslint}/bin/eslint\ --fix\ %<cr>
      '';
      css = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      nix = ''
        setl formatprg=nixpkgs-fmt
      '';
      dhall = ''
        setl formatprg=dhall\ format
      '';
      make = ''
        setl noexpandtab
      '';
      lua = ''
        setl makeprg=luacheck\ --formatter\ plain
        nnoremap <buffer> <localleader>m :make %<cr>
      '';
      go = ''
        setl formatprg=gofmt makeprg=go\ build\ -o\ /dev/null
        nnoremap <buffer> <localleader>m :make %<cr>
        nnoremap <buffer> <localleader>i :%!goimports<cr>
        nnoremap <buffer> <localleader>t :execute ':silent !for f in ./{cmd, internal, pkg}; if test -d $f; ctags -R $f; end; end'<CR>
      '';
      haskell = ''
        setl formatprg=ormolu
        nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
      '';
      markdown = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
    };

    programs.neovim = {
      enable = true;

      package = pkgs.neovim-unwrapped;

      extraConfig = ''
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

        function! LspStatus() abort
            if luaeval('#vim.lsp.buf_get_clients() > 0')
              return luaeval("require('lsp-status').status()")
            endif

            return ""
        endfunction

        set background=light foldmethod=indent expandtab tabstop=2 shiftwidth=2 colorcolumn=100
        set timeoutlen=500 formatoptions=tcrqjn hidden number ignorecase smartcase
        set wildignore+=*.git/*,nix/sources.nix,*.min.*
          \,*.map,*.idea,*build/*,.direnv/*,*dist/*,*compiled/*,*tmp/*
        set inccommand=split splitbelow splitright foldlevelstart=99 undofile
        set termguicolors grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
        set completeopt=menuone,noselect,noinsert
        set path-=/usr/include list lcs=trail:¬,tab:\ \ 
        set statusline+=\ %f\ %m%=%{LspStatus()}%y\ %q\ %3l:%2c\ \|%3p%%\ 
        let g:yui_comments = 'bg'
        colorscheme yui

        let g:EditorConfig_max_line_indicator = "exceeding"
        let g:EditorConfig_preserve_formatoptions = 1

        let g:sneak#label      = 1
        let g:sneak#use_ic_scs = 1
        let g:sneak#s_next = 1

        let g:peekaboo_window = 'vert bo 40new'

        let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
        let g:gutentags_file_list_command = 'rg\ --files'

        let g:grepper = {}
        let g:grepper.tools = ['rg', 'git']

        aug terminsert | exe "au! TermOpen * startinsert | setl nonu nornu" | aug END

        aug quickfix
            au!
            au QuickFixCmdPost [^l]* cwindow
            au QuickFixCmdPost l* lwindow
        aug END

        aug highlight_yank | exe "au! TextYankPost * silent! lua require'vim.highlight'.on_yank()" | aug END

        let mapleader = " "
        let maplocalleader = ","

        imap     jk        <Esc>
        tnoremap <Esc>     <C-\><C-n>
        nnoremap <BS>      <C-^>
        nnoremap <leader><leader> :update<cr>
        nnoremap <leader>z        :wq<cr>
        nnoremap Y         y$

        " ======= easy align ================
        " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
        vmap <Enter> <Plug>(EasyAlign)
        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)

        " nnoremap <leader>fw :grep -wF <cword><cr>
        " nnoremap <leader>fs :grep 
        " nnoremap <leader>ff :find 

        " ======= fzf =======================
        nnoremap <leader>fz :Files<cr>
        nnoremap <leader>fl :BLines<cr>
        nnoremap <leader>ft :Tags<cr>
        nnoremap <leader>fm :Marks<cr>
        nnoremap <leader>fW :Windows<cr>
        nnoremap <leader>fb :Buffers<cr>
        " nnoremap <leader>fb :ls<cr>:buffer<Space>

        " ======= grepper ===================
        nmap gs  <plug>(GrepperOperator)
        xmap gs  <plug>(GrepperOperator)
        nnoremap <leader>fs :GrepperRg 
        nnoremap <leader>fi :GrepperGit 

        " ======= sneak =====================
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_t
        map T <Plug>Sneak_T

        nmap     <leader>rb :call FormatBuffer()<cr>
        nnoremap <leader>rc :set operatorfunc=ReflowComment<cr>g@
        vnoremap <leader>rc :<C-u>call ReflowComment(visualmode())<cr>

        nnoremap <leader>/ :nohlsearch<CR>

        nnoremap <leader>T :lcd %:p:h<bar>split term://fish<CR>
        nnoremap <leader>t :split term://fish<CR>

        " ======= sad =======================
        map      <leader>C <Plug>(sad-change-backward)
        map      <leader>c <Plug>(sad-change-forward)

        " ======= sandwich ==================
        let g:sandwich_no_default_key_mappings = 1
        silent! nmap <unique><silent> <leader>sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> <leader>sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> <leader>sD <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
        silent! nmap <unique><silent> <leader>sR <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

        let g:operator_sandwich_no_default_key_mappings = 1
        silent! nmap <unique> <leader>sa <Plug>(operator-sandwich-add)
        silent! xmap <unique> <leader>sa <Plug>(operator-sandwich-add)
        silent! omap <unique> <leader>sa <Plug>(operator-sandwich-g@)
        silent! xmap <unique> <leader>sd <Plug>(operator-sandwich-delete)
        silent! xmap <unique> <leader>sr <Plug>(operator-sandwich-replace)

        " ======= VIMTEX ====================
        let g:tex_flavor = 'latex'
        let g:vimtex_view_method = 'zathura'
        nnoremap <localleader>lt :call vimtex#fzf#run('cl')<cr>

        " ======= lsp =======================
        packadd nvim-lspconfig
        lua <<EOF
        local mappings = {
          h = "lua vim.lsp.buf.hover()",
          i = "lua vim.lsp.buf.signature_help()",
          e = "lua vim.lsp.buf.rename()",
          r = "lua vim.lsp.buf.references()",
          H = "lua vim.lsp.buf.implementation()",
          j = "lua vim.lsp.buf.definition()",
          k = "lua vim.lsp.buf.type_definition()",
          d = "lua vim.lsp.diagnostic.show_line_diagnostics({ border = 'single' })",
          w = "lua vim.lsp.buf.workspace_symbol()",
          u = "lua vim.lsp.buf.document_symbol()",
          R = "lua vim.lsp.buf.server_ready()",
          p = "lua vim.lsp.buf.document_highlight()",
          n = "lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = 'single' }})",
          b = "lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = 'single' }})",
          l = "lua vim.lsp.diagnostic.set_loclist()"
        }
        for k, v in pairs(mappings) do
          vim.api.nvim_set_keymap('n', '<localleader>l' .. k, '<cmd>' .. v .. '<cr>', { noremap=true, silent=true })
        end

        local lsp_status = require('lsp-status')
        local nvim_lsp = require'lspconfig'

        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            lsp_status.on_attach(client)
        end

        local configs = require'lspconfig/configs'

        nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { on_attach = on_attach })

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

        nvim_lsp.rust_analyzer.setup{on_attach=on_attach,capabilities=lsp_status.capabilities}
        -- https://github.com/neovim/neovim/issues/13829
        -- nvim_lsp.purescriptls.setup{}
        nvim_lsp.gopls.setup{on_attach=on_attach,capabilities=lsp_status.capabilities}
        nvim_lsp.hls.setup{on_attach=on_attach,capabilities=lsp_status.capabilities}
        nvim_lsp.dhall_lsp_server.setup{}

        require('lspfuzzy').setup {}
        EOF
      '';

      plugins = with pkgs.vimPlugins; [
        lsp-status-nvim
        { plugin = nvim-lspconfig; optional = true; }
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "lspfuzzy"; src = lspfuzzy; })
        { plugin = (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "parinfer-rust"; src = sources."parinfer"; }); optional = true; }
        { plugin = conjure; optional = true; }
        vim-fugitive
        vim-eunuch
        vim-unimpaired
        vimtex
        vim-repeat
        vim-commentary
        editorconfig-vim
        vim-easy-align
        vim-grepper
        vim-indent-object
        QFEnter
        vim-dirvish
        fzfWrapper
        fzf-vim
        vim-gutentags
        vim-sandwich
        vim-sneak
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "sad"; src = sad; })
        unicode-vim
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "visual-split.vim"; src = sources."visual-split.vim"; })
        vim-peekaboo

        (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "yui"; src = yui; })
        iceberg-vim

        dhall-vim
        haskell-vim
        Jenkinsfile-vim-syntax
        purescript-vim
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "vim-js"; src = sources."vim-js"; })
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec { name = "vim-lua"; src = sources."vim-lua"; })
        vim-jsx-pretty
        vim-nix
        vim-terraform
      ];
    };
  };
}

