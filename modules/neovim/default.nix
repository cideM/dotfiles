args @ {
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with types; let
  makeFtPlugins = ftplugins:
    with attrsets;
      mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" {text = value;})
      ftplugins;
in {
  config = {
    xdg.configFile = makeFtPlugins {
      xml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      cpp = ''
        compiler gcc
        setl formatprg=clang-format
      '';
      zig = ''
        compiler zig
      '';
      sh = ''
        compiler shellcheck
      '';
      rust = ''
        compiler rustc
        setl formatprg=rustfmt
      '';
      janet = ''
        setl formatprg=janet-format
      '';
      purescript = ''
        setl formatprg=purty\ format\ -
      '';
      python = ''
        setl formatprg=black\ -q\ -
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      javascript = ''
        compiler eslint
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json

        if executable('deno')
          setl formatprg=deno\ fmt\ -
          setl makeprg=deno\ lint\ %
        else
          setl formatprg=prettier\ --stdin-filepath\ %
          setl makeprg=eslint\ --format\ compact
        endif
      '';
      astro = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json,./.astro
      '';
      typescript = ''
        compiler tsc
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        if executable('deno')
          setl formatprg=deno\ fmt\ -
        else
          setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        endif
      '';
      html = ''
        setl formatprg=prettier\ --parser\ html\ --stdin-filepath\ %
      '';
      css = ''
        setlocal iskeyword+=-
        setl formatprg=prettier\ --parser\ css\ --stdin-filepath\ %
      '';
      scss = ''
        setlocal iskeyword+=-
        setl formatprg=prettier\ --parser\ scss
      '';
      nix = ''
        setlocal iskeyword+=-
        setl formatprg=alejandra\ -q
      '';
      dhall = ''
        setl formatprg=dhall\ format
      '';
      make = ''
        setl noexpandtab
      '';
      graphql = ''
        setl formatprg=prettier\ --parser=graphql
      '';
      lua = ''
        set formatprg=stylua\ --search-parent-directories\ --stdin-filepath\ %\ -
      '';
      sql = ''
        setl formatprg=pg_format\ -g
      '';
      go = ''
        compiler go
        setl formatprg=gofmt
        function! GoImports()
            let saved = winsaveview()
            %!goimports
            call winrestview(saved)
        endfunction
        nnoremap <buffer> <localleader>i :call GoImports()<cr>
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
       
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

      extraConfig = builtins.readFile ./init.vim;

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        vim-fugitive
        vim-repeat
        vim-indent-object
        nvim-treesitter-context
        vim-rhubarb
        telescope-nvim
        vim-sandwich
        sad-vim
        gitsigns-nvim
        conjure
        vim-dirvish
        leap-nvim
        vim-eunuch
        # lightline-vim
        janet-vim
        nvim-treesitter.withAllGrammars

        # Themes
        yui
        catppuccin-nvim
      ];
    };
  };
}
