{ config, lib, pkgs, ... }:

{
  "nvim/ftplugin/help.vim" = {
    text = ''
      let b:indent_blankline_enabled=0
    '';
  };
  "nvim/ftplugin/git.vim" = {
    text = ''
      let b:indent_blankline_enabled=0
    '';
  };
  "nvim/ftplugin/fugitive.vim" = {
    text = ''
      let b:indent_blankline_enabled=0
    '';
  };
  "nvim/ftplugin/toggleterm.vim" = {
    text = ''
      let b:indent_blankline_enabled=0
    '';
  };
  "nvim/ftplugin/xml.vim" = {
    text = ''
      setl fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ %
    '';
  };
  "nvim/ftplugin/vim.vim" = {
    text = ''
      setlocal foldmethod=indent
    '';
  };
  "nvim/ftplugin/sh.vim" = {
    text = ''
      setl fdm=indent makeprg=${pkgs.shellcheck}/bin/shellcheck\ -f\ gcc\ % fp=shfmt

      nnoremap <buffer> <localleader>m :silent make<CR>
    '';
  };
  "nvim/ftplugin/rust.vim" = {
    text = ''
      setl mp=${pkgs.cargo}/bin/cargo\ check fp=rustfmt
    '';
  };
  "nvim/ftplugin/purescript.vim" = {
    text = ''
      setl fp=${pkgs.nodePackages.purty}/bin/purty\ format\ -
      command! -buffer SpagoTags :execute '!spago docs --format ctags'
    '';
  };
  "nvim/ftplugin/nix.vim" = {
    text = ''
      setl fp=${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt fdm=indent
    '';
  };
  "nvim/ftplugin/markdown.vim" = {
    text = ''
      setl fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ %
    '';
  };
  "nvim/ftplugin/make.vim" = {
    text = ''
      setl sw=4 ts=4 noea
    '';
  };
  "nvim/ftplugin/lua.vim" = {
    text = ''
      setl mp=${pkgs.lua53Packages.luacheck}/bin/luacheck\ --formatter\ plain
      setl fdm=syntax
      nnoremap <buffer> <silent> <localleader>m :make %<cr>
    '';
  };
  "nvim/ftplugin/json.vim" = {
    text = ''
      setl fdm=expr fde=nvim_treesitter#foldexpr() fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ %
    '';
  };
  "nvim/ftplugin/javascript.vim" = {
    text = ''
      setl fdm=expr fde=nvim_treesitter#foldexpr() sua+=.js,.jsx,.css wig+=*/node_modules/*
        \mp=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        \efm=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        \fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ %

      nnoremap <buffer> <silent> <localleader>f :!${pkgs.nodePackages.eslint}/bin/eslint\ --fix\ %
      nnoremap <buffer> <silent> <localleader>m :make %<cr>
    '';
  };
  "nvim/ftplugin/dhall.vim" = {
    text = ''
      setl isk+=. fp=${pkgs.dhall}/bin/dhall\ format
      nnoremap <buffer> <localleader>m :make %<cr>
    '';
  };
  "nvim/ftplugin/css.vim" = {
    text = ''
      setl sua+=.js,.jsx,.css fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ %
    '';
  };
  "nvim/ftplugin/go.vim" = {
    text = ''
      compiler go
      setl fdm=expr fde=nvim_treesitter#foldexpr() fp=gofmt mp=go\ build\ -o\ /dev/null fp=gofmt\\|goimports
      nnoremap <localleader>m :execute 'make ' . expand('%:p:h')<CR>
      nnoremap <localleader>t :execute ':silent !for f in ./{cmd, internal, pkg}; if test -d $f; ctags -R $f; end; end'<CR>
    '';
  };
  "nvim/ftplugin/typescript.vim" = {
    text = ''
      setl fdm=expr fde=nvim_treesitter#foldexpr() sua+=.ts,.tsx,.css wig+=*/node_modules/*
        \mp=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        \efm=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        \fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ %

      nnoremap <buffer> <silent> <localleader>f :!${pkgs.nodePackages.eslint}/bin/eslint\ --fix\ %
    '';
  };
  "nvim/ftplugin/python.vim" = {
    text = ''
      setl fdm=expr fde=nvim_treesitter#foldexpr()
    '';
  };
  "nvim/ftplugin/haskell.vim" = {
    text = ''
      " https://github.com/tree-sitter/tree-sitter-haskell/issues/33
      " setlocal foldmethod=expr
      " setlocal foldexpr=nvim_treesitter#foldexpr()
      " let b:undo_ftplugin .= '|setlocal foldexpr<'
      " let b:undo_ftplugin .= '|setlocal foldmethod<'
      setl fp=${pkgs.ormolu}/bin/ormolu
      nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
    '';
  };
  "nvim/ftplugin/clojure.vim" = {
    text = ''
      let current_compiler="clj-kondo"
      packadd parinfer-rust
      packadd conjure
      " https://github.com/borkdude/clj-kondo/blob/master/doc/editor-integration.md#vanilla-way
      setl wig+=*/.clj-kondo/* efm=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
        \mp=clj-kondo\ --lint\ %
        \fdm=expr fde=nvim_treesitter#foldexpr()
    '';
  };
  "nvim/ftplugin/yaml.vim" = {
    text = ''
      setl fp=${pkgs.nodePackages.prettier}/bin/prettier\ --stdin-filepath\ % fdm=expr fde=nvim_treesitter#foldexpr()
    '';
  };
}
