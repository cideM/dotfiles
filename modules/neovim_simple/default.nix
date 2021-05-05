args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  cfg = config.programs.neovim;

  sources = config.sources;
in
{
  config = {
    programs.neovim = {
      enable = true;

      package = pkgs.neovim-unwrapped;

      extraConfig = ''
        set bg=light fdm=indent et ts=2 sw=2 tm=500 noea fo=tcrqjn
        set hid nu scs icm=split sb spr fdls=99 udf tgc
        set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
        set path-=/usr/include
        set list lcs=trail:¬
        let g:yui_comments = 'bg'
        colorscheme yui
        let g:EditorConfig_max_line_indicator = "exceeding"
        let g:EditorConfig_preserve_formatoptions = 1
        let g:sneak#label      = 1
        let g:sneak#use_ic_scs = 1
        let g:sneak#s_next = 1

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

        augroup highlight_yank
            autocmd!
            autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
        augroup END

        let mapleader = " "
        let maplocalleader = ","

        imap     jk        <Esc>
        tnoremap <Esc>     <C-\><C-n>
        nnoremap <BS>      <C-^>
        nnoremap Y         y$
        nmap     <leader>q :call FormatBuffer()<cr>
        nnoremap <leader>/ :nohlsearch<CR>
        nnoremap <leader>T :split <Bar> lcd %:p:h <Bar> term://fish<CR>
        nnoremap <leader>b :ls<cr>:buffer<Space>
        nnoremap <leader>r :set operatorfunc=ReflowComment<cr>g@
        nnoremap <leader>t :split <Bar> term://fish<CR>
        vnoremap <leader>r :<C-u>call ReflowComment(visualmode())<cr>
        map      <leader>C <Plug>(sad-change-backward)
        map      <leader>c <Plug>(sad-change-forward)
        map      <leader>j <Plug>Sneak_s
        map      <leader>k <Plug>Sneak_S
        map      F         <Plug>Sneak_F
        map      T         <Plug>Sneak_T
        map      f         <Plug>Sneak_f
        map      t         <Plug>Sneak_t
        omap     O         <Plug>Sneak_S
        omap     o         <Plug>Sneak_s
        vmap     <Enter>   <Plug>(EasyAlign)

        autocmd FileType xml setl fp='prettier --stdin-filepath ' . expand('%')
        autocmd FileType sh setl fp=shfmt mp='shellcheck -f gcc %' | nnoremap <buffer> <localleader>m :silent make<cr>
        autocmd FileType rust setl fp=rustfmt mp=cargo\ check
        autocmd FileType purescript setl fp=purty\ format | nnoremap <buffer> <localleader>t :!spago\ docs\ --format\ ctags
        autocmd FileType nix setl fp=nixpkgs-fmt
        autocmd FileType css setl fp='prettier --stdin-filepath ' . expand('%')
        autocmd FileType dhall setl fp=dhall\ format
        autocmd FileType make setl noet
        autocmd FileType lua setl mp=luacheck\ --formatter\ plain
          \| nnoremap <localleader>m make\ %
        autocmd FileType go setl fp=gofmt\\|goimports makeprg=go\ build\ -o\ /dev/null
          \| nnoremap <localleader>m make\ expand('%:p:h')
          \| nnoremap <localleader>t :execute ':silent !for f in ./{cmd, internal, pkg}; if test -d $f; ctags -R $f; end; end'<CR>
        autocmd FileType haskell setl fp=ormolu | nnoremap <buffer> <localleader>t :silent\ !fast-tags\ -R\ .
        autocmd FileType markdown setl fp='prettier --stdin-filepath ' . expand('%')
        autocmd FileType json setl fp='prettier --stdin-filepath ' . expand('%')
        autocmd FileType javascript setl fp='prettier --stdin-filepath ' . expand('%')
        autocmd FileType typescript setl fp='prettier --stdin-filepath ' . expand('%') wig+=*node_modules*
          \efm=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%# makeprg=tslint\ --format\ compact
          \| nnoremap <buffer> <silent> <localleader>f :!tslint\ --fix\ %
        autocmd FileType yaml setl fp='prettier --stdin-filepath ' . expand('%')
        autocmd FileType clojure setl efm=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
          \| mp=clj-kondo\ --lint\ % wig+=*.clj-kondo*
          " not sure if this is needed
          "\| let current_compiler=clj-kondo
      '';

      plugins = with pkgs.vimPlugins; with (import ../neovim/thirdparty.nix args); [
        editorconfig-vim
        vim-commentary
        vim-easy-align
        vim-repeat
        vim-gutentags
        vim-sandwich
        vim-sneak
        unicode-vim
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          name = "visual-split.vim";
          src = sources."visual-split.vim";
        })
        # nvim-hlslens
        # nvim-autopairs
        # nvim-lspfuzzy
        # lsp-status-nvim
        # nvim-lspconfig
        vim-peekaboo
        visual-split
        vim-fugitive
        yui
        iceberg-vim

        dhall-vim
        haskell-vim
        Jenkinsfile-vim-syntax
        purescript-vim
        vim-js
        vim-jsx-pretty
        vim-lua
        vim-nix
        vim-terraform
      ];
    };
  };
}

