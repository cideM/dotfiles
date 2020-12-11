{ config, lib, pkgs, ... }:

with lib;
with types;
let
  cfg = config.programs.neovim;

  grammarConfigModule = submodule {
    options = {
      rev = mkOption {
        type = str;
        description = ''
          Git revision to fetch for this grammar (copy & paste the Git sha)
        '';
      };

    };
  };

  # TODO: Add all from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
  # TODO: Add them to nixpkgs once I've figured out how
  grammarGo = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-go-${version}";
    src = builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = options.go.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/go.so -I$src/src $src/src/parser.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarYaml = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-yaml-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = options.yaml.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      ${pkgs.clang}/bin/clang++ -o parser/yaml.so -I$src/src $src/src/parser.c $src/src/scanner.cc -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarTs = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-ts-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = options.ts.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/typescript.so -I$src/typescript/src $src/typescript/src/parser.c $src/typescript/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarTsx = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-tsx-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = options.tsx.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/tsx.so -I$src/tsx/src $src/tsx/src/parser.c $src/tsx/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  init = ''
    " ==============================
    " =       GENERAL SETTINGS     =
    " ==============================
    " Don't load the built-in plugin so that the custom 'matchup' plugin is the
    " only such plugin that is active.
    " This doesn't seem to work
    let g:loaded_matchit = 1

    set background=light
    set tabstop=4
    set list
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
    ${if cfg.completion.enable && cfg.completion.plugin == "completion-nvim" then ''
    set completeopt=menuone,noinsert,noselect
    '' else ''
    set completeopt-=preview
    ''}
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

    " ==============================
    " =        COLORSCHEME         =
    " ==============================
    augroup my_neomake_highlights
        au!
        autocmd ColorScheme *
          \ highlight link SneakScope IncSearch
    augroup END
    let g:yui_comments = "emphasize"
    colorscheme github

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

    " ==============================
    " =          PLUGINS           =
    " ==============================

    " ======= EDITORCONFIG ==============
    let g:EditorConfig_max_line_indicator = "exceeding"
    let g:EditorConfig_preserve_formatoptions = 1

    " ======= NVIM COLORIZER ============
    packadd nvim-colorizer
    lua require'colorizer'.setup()

    " ======= MARKDOWN FOLDING ==========
    let g:markdown_fold_style = "nested"

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

    " ======= GUTENTAGS =================
    " No ctags for Haskell
    let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
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
        virtual_text = false,
        signs = false,
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
    nvim_lsp.dhall.setup{}
    EOF

    ${if cfg.treesitter.enable then ''
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
    '' else ""}

    ${if cfg.telescope.enable then ''
      " ======= TELESCOPE =================
      packadd telescope
      nnoremap ${cfg.telescope.prefix}p  <cmd>Telescope find_files<cr>
      nnoremap ${cfg.telescope.prefix}b  <cmd>Telescope buffers<cr>
      nnoremap ${cfg.telescope.prefix}g  <cmd>Telescope live_grep<cr>
      nnoremap ${cfg.telescope.prefix}ds <cmd>Telescope lsp_document_symbols<cr>
      nnoremap ${cfg.telescope.prefix}ws <cmd>Telescope lsp_workspace_symbols<cr>
      nnoremap ${cfg.telescope.prefix}m  <cmd>Telescope marks<cr>
      nnoremap ${cfg.telescope.prefix}gf <cmd>Telescope git_files<cr>
      nnoremap ${cfg.telescope.prefix}l  <cmd>Telescope current_buffer_fuzzy_find<cr>
      nnoremap ${cfg.telescope.prefix}w  <cmd>Telescope grep_string<cr>
      nnoremap ${cfg.telescope.prefix}p  <cmd>Telescope builtin<cr>
      nnoremap ${cfg.telescope.prefix}a  <cmd>Telescope tags<cr>
      nnoremap ${cfg.telescope.prefix}t  <cmd>Telescope current_buffer_tags<cr>
    '' else ""}

    ${if cfg.completion.enable && cfg.completion.plugin == "completion-nvim" then ''
      " ======= COMPLETION ================
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      let g:completion_auto_change_source = 1

      " Activate it for all buffers for buffer, tag and path completion
      autocmd BufEnter * lua require'completion'.on_attach()
      imap  <c-j> <Plug>(completion_next_source)
      imap  <c-k> <Plug>(completion_prev_source)
      let g:completion_chain_complete_list = {
          \'default': [
          \   {'complete_items': ['lsp']},
          \   {'complete_items': ['buffers']},
          \   {'mode': '<c-p>'},
          \   {'mode': '<c-n>'}
          \   {'complete_items': ['tags']},
          \   {'complete_items': ['path']},
          \]
          \}
    '' else ""}
  '';

  ftPluginDir = toString ./ftplugin;

  # For ./. see https://github.com/NixOS/nix/issues/1074 otherwise it's not an
  # absolute path
  readFtplugin = name: builtins.readFile ("${ftPluginDir}/${name}.vim");

  plugins = (import ./plugins.nix { inherit pkgs; sources = config.sources; });

  # TODO: Should just add all automatically
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
        "goutils"
      ];

  # TODO: Should just add all automatically
  ftPlugins =
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

  ftPluginsAttrs = attrsets.mapAttrs'
    (ft: vimscript:
      attrsets.nameValuePair ("nvim/ftplugin/${ft}.vim") ({
        text = ''
          " Generated by my Nix neovim module, all edits will be lost if not
          " made in the Nix source
        '' + vimscript;
      })
    )
    ftPlugins;

in
{
  # TODO: Add fugitive, sneak, asterisk, sad and lsp
  options.programs.neovim.completion = {
    enable = mkOption {
      type = bool;
      description = "Whether to use a special plugin for completion, such as 'mucomplete' or 'completion-nvim'";
      default = false;
    };

    plugin = mkOption {
      type = enum [ "completion-nvim" ];
      default = "completion-nvim";
    };
  };

  options.programs.neovim.telescope = {

    enable = mkOption {
      type = bool;
      description = "Whether to enable the telescope plugin (and dependencies)";
      default = false;
    };

    prefix = mkOption {
      type = str;
      description = "Prefix to use for all telescope mappings";
      default = "<leader>t";
    };

  };

  options.programs.neovim.git = {

    committia = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

    gv = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

    signify = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

    messenger = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

  };

  options.programs.neovim.editor = {
    highlight-current-word = mkOption {
      type = bool;
      description = "Install a plugin ('vim-illuminate') which highlights the word under the cursor";
      default = false;
    };
  };

  options.programs.neovim.treesitter = {

    enable = mkOption {
      type = bool;
      description = "Whether to enable treesitter grammars for Neovim (will install 'nvim-treesitter')";
      default = false;
    };

    go = mkOption {
      type = grammarConfigModule;
      description = "Go treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    ts = mkOption {
      type = grammarConfigModule;
      description = "Typescript treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    tsx = mkOption {
      type = grammarConfigModule;
      description = "Typescript TSX treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    yaml = mkOption {
      type = grammarConfigModule;
      description = "Yaml treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

  };

  config = {
    xdg.configFile = (
      ftPluginsAttrs // {
        "nvim/ftplugin/go.vim" = {
          text = ''
            let b:undo_ftplugin = ""

            compiler go

            ${if cfg.treesitter.enable then ''
              setlocal foldmethod=expr
              setlocal foldexpr=nvim_treesitter#foldexpr()
              let b:undo_ftplugin .= '|setlocal foldexpr<'
              '' else ''
              setlocal foldmethod=syntax
            ''}
            let b:undo_ftplugin .= '|setlocal foldmethod<'

            setlocal formatprg=gofmt
            let b:undo_ftplugin .= '|setlocal formatprg<'

            " https://github.com/leeren/dotfiles/blob/master/vim/.vim/ftplugin/go.vim
            command! -buffer -range=% Gofmt let b:winview = winsaveview() |
              \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
              \ call winrestview(b:winview)

            command! -buffer -range=% Goimport let b:winview = winsaveview() |
              \ silent! execute <line1> . "," . <line2> . "!goimports " | 
              \ call winrestview(b:winview)

            nnoremap <silent> <localleader>mc :execute 'make ' . expand('%:p:h')<CR>
            nnoremap <silent> <localleader>mm :make ./...<CR>
            nnoremap <silent> <localleader>i :Goimport<CR>
            nnoremap <silent> <localleader>ma :call goutils#MakeprgAsyncProject()<CR>
            nnoremap <silent> <localleader>tw :call goutils#RunTestAtCursor()<CR>
            nnoremap <silent> <localleader>ta :call goutils#RunAllTests()<CR>
          '';
        };
        "nvim/ftplugin/typescript.vim" = {
          text = ''
            let b:undo_ftplugin = ""

            let node_modules = luaeval(
                        \'require("findUp").findUp(unpack(_A))', 
                        \['node_modules',expand('%:p:h'), '/']
                        \)

            """""""""""""""""""""""""
            "      PRETTIER         "
            """""""""""""""""""""""""
            let prettier_path = ""

            if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
                let prettier_path = node_modules . "/.bin/prettier"
            elseif executable("prettier")
                let prettier_path = "prettier"
            end

            if prettier_path !=# ""
                let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
                let b:undo_ftplugin .= '|setlocal formatprg<'
            end

            """""""""""""""""""""""""
            "        TSLINT         "
            """""""""""""""""""""""""
            let tslint_path = ""

            if node_modules !=# "false" && filereadable(node_modules . "/.bin/tslint")
                let tslint_path = node_modules . "/.bin/tslint"
            elseif executable("tslint")
                let tslint_path = "tslint"
            end

            if tslint_path !=# ""
                let &makeprg=tslint_path . ' --format compact '
                setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
                let b:undo_ftplugin .= '|setlocal makeprg<'

                command! -bar -buffer Fix call system(tslint_path . ' --fix ' . expand('%')) | edit
                nnoremap <buffer> <silent> <localleader>f :Fix<cr>
            end

            set wildignore+=*/node_modules/*
            let b:undo_ftplugin .= '|setlocal wildignore<'

            setlocal suffixesadd+=.ts,.tsx,.css
            let b:undo_ftplugin .= '|setlocal suffixesadd<'

            ${if cfg.treesitter.enable then ''
              setlocal foldmethod=expr
              setlocal foldexpr=nvim_treesitter#foldexpr()
              let b:undo_ftplugin .= '|setlocal foldexpr<'
              '' else ''
              setlocal foldmethod=syntax
            ''}

          '';
        };
        "nvim/ftplugin/yaml.vim" = {
          text = ''
            let b:undo_ftplugin = ""

            ${if cfg.treesitter.enable then ''
              setlocal foldmethod=expr
              setlocal foldexpr=nvim_treesitter#foldexpr()
              let b:undo_ftplugin .= '|setlocal foldexpr<'
              '' else ''
              setlocal foldmethod=indent
            ''}

            let node_modules = luaeval(
                        \'require("findUp").findUp(unpack(_A))', 
                        \['node_modules',expand('%:p:h'), '/']
                        \)

            """""""""""""""""""""""""
            "      PRETTIER         "
            """""""""""""""""""""""""
            let prettier_path = ""

            if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
                let prettier_path = node_modules . "/.bin/prettier"
            elseif executable("prettier")
                let prettier_path = "prettier"
            end

            if prettier_path !=# ""
                let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
                let b:undo_ftplugin .= '|setlocal formatprg<'
            end
          '';
        };
      }
    );

    programs.neovim = {
      enable = true;

      package = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "master";
        src = config.sources.neovim;
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.tree-sitter ];
      });

      configure = with pkgs.vimPlugins; with plugins; {
        customRC = init;

        packages = {
          foobar = {
            start = [

              editorconfig-vim
              limelight-vim
              sad
              targets-vim
              vim-asterisk
              vim-colortemplate
              vim-commentary
              vim-easy-align
              vim-eunuch
              vim-gutentags
              vim-indent-object
              vim-matchup
              vim-peekaboo
              vim-repeat
              vim-sandwich
              vim-sneak
              vim-unimpaired
              vim-dirvish

              # Git
              vim-fugitive
              vim-rhubarb

              # Language Tooling
              vim-markdown-folding

              # Languages & Syntax
              purescript-vim
              vim-nix
              dhall-vim
              vim-js
              vim-lua
              yats-vim
              vim-jsx-pretty
              Jenkinsfile-vim-syntax
              haskell-vim
              vim-terraform

              # Themes
              apprentice
              vim-colors-github
              yui

            ]
            ++ localPlugins
            ++ (if cfg.treesitter.enable then [ grammarGo grammarYaml grammarTs grammarTsx ] else [ ])
            ++ (if cfg.completion.enable && cfg.completion.plugin == "completion-nvim" then [ completion-nvim completion-buffers completion-tags ] else [ ])
            ++ (if cfg.editor.highlight-current-word then [ vim-illuminate ] else [ ])
            ++ (if cfg.git.committia.enable then [ committia ] else [ ])
            ++ (if cfg.git.signify.enable then [ vim-signify ] else [ ])
            ++ (if cfg.git.gv.enable then [ gv-vim ] else [ ])
            ++ (if cfg.git.messenger.enable then [ git-messenger-vim ] else [ ]);

            opt = [
              nvim-lsp
              nvim-colorizer
            ]
            ++ (if cfg.treesitter.enable then [ nvim-treesitter ] else [ ]);
          };
        };
      };
    };
  };
}
