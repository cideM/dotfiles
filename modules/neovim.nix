args@{ config
, lib
, pkgs
, ...
}:

with lib;
with types;
let

  makeFtPlugins = ftplugins: with attrsets;
    mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" ({ text = value; }))
      ftplugins;
in
{
  config = {
    xdg.configFile = makeFtPlugins {
      xml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      zig = ''
        setl formatprg=${pkgs.zigpkgs.master}/bin/zig\ fmt\ --stdin
      '';
      sh = ''
        setl makeprg=shellcheck\ -f\ gcc\ %
      '';
      rust = ''
        setl formatprg=rustfmt
        setl makeprg=cargo\ check
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      purescript = ''
        setl formatprg=purty\ format\ -
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      fzf = ''
        setl laststatus=0 noshowmode noruler
        aug fzf | au! BufLeave <buffer> set laststatus& showmode ruler | aug END
      '';
      clojure = ''
        packadd conjure
        packadd parinfer
        setl errorformat=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
        setl makeprg=clj-kondo\ --lint\ %
        setl wildignore+=*.clj-kondo*
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      javascript = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      typescript = ''
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      html = ''
        setl formatprg=prettier\ --parser\ html\ --stdin-filepath\ %
      '';
      css = ''
        setl formatprg=prettier\ --parser\ css\ --stdin-filepath\ %
      '';
      scss = ''
        setl formatprg=prettier\ --parser\ scss\ --stdin-filepath\ %
      '';
      nix = ''
        setl formatprg=${pkgs.alejandra}/bin/alejandra\ -q
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      dhall = ''
        setl formatprg=dhall\ format
      '';
      make = ''
        setl noexpandtab
      '';
      lua = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set formatprg=stylua\ -
      '';
      python = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      sql = ''
        setl formatprg=${pkgs.pgformatter}/bin/pg_format\ -g
      '';
      go = ''
        setl formatprg=gofmt
        setl makeprg=go\ build\ -o\ /dev/null
        function! GoImports()
            let saved = winsaveview()
            %!goimports
            call winrestview(saved)
        endfunction
        nnoremap <buffer> <localleader>i :call GoImports()<cr>
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      haskell = ''
        setl formatprg=ormolu\ --stdin-input-file\ %
      '';
      markdown = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
    };

    programs.neovim = {
      enable = true;

      extraConfig = ''
        " Format the buffer with the current formatprg. Most of the custom code here
        " is just so my jump list isn't cluttered and I always end up at the first
        " line when undoing a FormatBuffer call. See the linked post.
        function! FormatBuffer()
          setl formatexpr=
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

        set background=light
        set foldmethod=indent
        set expandtab
        set tabstop=2
        set laststatus=2
        set shiftwidth=2
        set colorcolumn=100
        set timeoutlen=500
        set formatoptions=crqjn
        set mouse=a
        set hidden
        set nonumber
        set ignorecase
        set smartcase
        set wildignore+=*.git/*,*.min.*,./result/*
          \,*.map,*.idea,*build/*,.direnv/*,*dist/*,*compiled/*,*tmp/*
        set inccommand=split
        set completeopt-=preview
        set splitbelow
        set splitright
        set foldlevelstart=99
        set undofile
        set termguicolors
        set grepprg=rg\ --vimgrep\ --smart-case
        set grepformat=%f:%l:%c:%m
        set path-=/usr/include list lcs=trail:¬,tab:\ \ 
        set statusline+=\ %f\ %m%=\ %y\ %q\ %3l:%2c\ \|%3p%%\ 
        " Fish is really slow on MacOS somehow
        set shell=${pkgs.dash}/bin/dash

        " COLOR STUFF
        let g:yui_comments = 'bg'

        let g:material_style = 'lighter'

        let g:github_hide_inactive_statusline = v:false

        let g:doom_one_terminal_colors = v:true
        let g:doom_one_italic_comments = v:true
        let g:doom_one_cursor_coloring = v:true

        colorscheme yui

        let g:EditorConfig_max_line_indicator = "exceeding"
        let g:EditorConfig_preserve_formatoptions = 1

        let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
        let g:gutentags_file_list_command = 'rg\ --files'
        " Okay very long story fucking short: due to whatever interactions my
        " Nix shells on Darwin have some weird stuff prepended to PATH, among
        " them some Toolchains/XcodeDefault.xctoolchain/bin which causes MacOS
        " ctags to be used which is of course from the stone age. At some point I
        " have to stop using Nix.
        let g:gutentags_ctags_executable = '${pkgs.universal-ctags}/bin/ctags'

        aug terminsert | exe "au! TermOpen * startinsert | setl nonu nornu" | aug END

        aug quickfix
            au!
            au QuickFixCmdPost [^l]* cwindow
            au QuickFixCmdPost l* lwindow
        aug END

        aug highlight_yank | exe "au! TextYankPost * silent! lua require'vim.highlight'.on_yank()" | aug END

        let mapleader = " "
        let maplocalleader = ","

        let g:indent_blankline_show_current_context = v:true
        let g:indent_blankline_show_current_context_start = v:true

        imap     jk        <Esc>
        tnoremap <Esc>     <C-\><C-n>
        nnoremap <BS>      <C-^>
        nnoremap <leader><leader> :update<cr>
        nnoremap <Leader>q :Sayonara<CR>
        nnoremap <Leader>Q :Sayonara!<CR>
        " https://github.com/junegunn/fzf.vim/pull/628
        inoremap <expr> <c-x><c-f> fzf#vim#complete("rg --files --hidden --no-ignore --null <Bar> xargs --null realpath --relative-to " . expand("%:h"))

        nnoremap <leader>G :Gitsigns<CR>

        " ======= easy align ================
        let g:easy_align_ignore_groups = []
        " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
        vmap <Enter> <Plug>(EasyAlign)
        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)

        " ======= fzf =======================
        let g:fzf_preview_window = ['up:60%', 'ctrl-/']
        let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
        nnoremap <leader>f :Files<cr>
        nnoremap <leader>l :BLines<cr>
        nnoremap <leader>t :Tags<cr>
        nnoremap <leader>m :Marks<cr>
        nnoremap <leader>b :Buffers<cr>
        nnoremap <leader>W :Windows<cr>

        nmap     <leader>F :call FormatBuffer()<cr>
        nnoremap <leader>R :set operatorfunc=ReflowComment<cr>g@
        vnoremap <leader>R :<C-u>call ReflowComment(visualmode())<cr>

        nnoremap <leader>/ :nohlsearch<CR>

        nnoremap <leader>T :split<bar>lcd %:p:h<bar>term fish<CR>
        nnoremap <leader>o :split<bar>term fish<CR>

        vnoremap <leader>gl :<C-U>execute ':Git log -L' . line("'<") . ',' . line("'>") . ':%'<CR>

        " ======= sad =======================
        map      <leader>C <Plug>(sad-change-backward)
        map      <leader>c <Plug>(sad-change-forward)

        " ======= sandwich ==================
        let g:sandwich_no_default_key_mappings = 1
        silent! nmap <unique><silent> <leader>d <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> <leader>p <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> <leader>D <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
        silent! nmap <unique><silent> <leader>P <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

        let g:operator_sandwich_no_default_key_mappings = 1
        silent! nmap <unique> <leader>a <Plug>(operator-sandwich-add)
        silent! xmap <unique> <leader>a <Plug>(operator-sandwich-add)
        silent! omap <unique> <leader>a <Plug>(operator-sandwich-g@)
        silent! xmap <unique> <leader>d <Plug>(operator-sandwich-delete)
        silent! xmap <unique> <leader>p <Plug>(operator-sandwich-replace)

        " ======= lsp =======================
        packadd nvim-lspconfig
        lua <<EOF
        vim.api.nvim_set_keymap('n', '<leader>L', "<cmd>lua vim.diagnostic.setloclist()<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', '<leader>S', "<cmd>lua vim.lsp.buf.document_symbol()<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('i', '<c-h>', "<cmd>lua vim.lsp.buf.signature_help()<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', '<leader>w', "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', '<leader>e', "<cmd>lua vim.lsp.buf.rename()<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', '<leader>n', "<cmd>lua vim.diagnostic.goto_next({ float = true })<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', '<leader>p', "<cmd>lua vim.diagnostic.goto_prev({ float = true })<cr>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', ']i', '<cmd>lua vim.lsp.buf.implementation()<cr>', { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', ']t', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap=true, silent=true })
        vim.api.nvim_set_keymap('n', '<C-p>', "<cmd>lua vim.diagnostic.open_float()<cr>", { noremap=true, silent=true })

        local nvim_lsp = require'lspconfig'

        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end

        local configs = require'lspconfig/configs'

        nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { on_attach = on_attach })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

        nvim_lsp.rust_analyzer.setup{}
        nvim_lsp.tsserver.setup{}
        nvim_lsp.gopls.setup{}
        nvim_lsp.zls.setup{}
        nvim_lsp.sumneko_lua.setup{}
        nvim_lsp.eslint.setup{}
        nvim_lsp.solargraph.setup{}

        require('lspfuzzy').setup {}

        require('leap').add_default_mappings()

        require("winshift").setup({
          highlight_moving_win = true,  -- Highlight the window being moved
          focused_hl_group = "Visual",  -- The highlight group used for the moving window
          moving_win_options = {
            -- These are local options applied to the moving window while it's
            -- being moved. They are unset when you leave Win-Move mode.
            wrap = false,
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = "",
          }
        })

        require'treesitter-context'.setup{ enable = true }

        require('gitsigns').setup()

        -- Treesitter
        require'nvim-treesitter.configs'.setup {
          ensure_installed = {},
          highlight = {
            enable = true,
            disable = {"zig"},
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
            disable = {},
          }
        }
        EOF
      '';

      plugins = with pkgs.vimPlugins; [
        # LSP
        { plugin = nvim-lspconfig; optional = true; }
        pkgs.lspfuzzy

        # Git
        vim-fugitive
        gitsigns-nvim
        vim-rhubarb

        vim-unimpaired
        pkgs.winshift
        vim-repeat
        vim-commentary
        editorconfig-vim
        vim-eunuch
        vim-indent-object
        vim-sayonara
        QFEnter
        fzfWrapper
        nvim-treesitter-context
        indent-blankline-nvim
        fzf-vim
        vim-gutentags
        pkgs.nvim-leap
        vim-sandwich
        sad-vim
        vim-dirvish

        # Themes
        lush-nvim
        edge
        pkgs.spacevim
        pkgs.yui
        pkgs.githubtheme
        everforest
        tokyonight-nvim
        rose-pine
        pkgs.arctic-lush-theme
        pkgs.jellybeans-lush-theme
        pkgs.onedarkpro-lush-theme

        # Language stuff
        { plugin = pkgs.parinfer-rust; optional = true; }
        { plugin = conjure; optional = true; }

        # Syntax
        haskell-vim
        dhall-vim
        zig-vim
        Jenkinsfile-vim-syntax
        purescript-vim
        pkgs.vim-js
        vim-lua
        vim-jsx-pretty
        vim-nix
        vim-terraform
        (nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars))

      ];
    };
  };
}

