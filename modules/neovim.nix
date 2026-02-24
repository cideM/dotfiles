{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with types;
let
  makeFtPlugins =
    ftplugins:
    with attrsets;
    mapAttrs' (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" { text = value; }) ftplugins;

  readFtPlugins =
    dir:
    let
      files = builtins.readDir dir;
    in
    mapAttrs' (name: type: nameValuePair "nvim/after/ftplugin/${name}" { source = "${dir}/${name}"; }) (
      filterAttrs (name: type: type == "regular") files
    );
in
{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    let
      janet-vim = pkgs.vimUtils.buildVimPlugin rec {
        version = "latest";
        pname = "janet-vim";
        src = inputs.janet-vim;
      };
    in
    {
      config = {
        xdg.configFile =
          (makeFtPlugins {
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
              setl formatprg=nixfmt\ -q
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
            '';
            haskell = ''
              setl formatprg=ormolu\ --stdin-input-file\ %
            '';
          })
          // (readFtPlugins ./neovim/ftplugins);

        programs.neovim = {
          enable = true;
          package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;

          initLua = builtins.readFile ./init.lua;

          plugins = with pkgs.vimPlugins; [
            # essential
            vim-fugitive
            sad-vim
            fzf-lua
            conform-nvim
            nvim-treesitter.withAllGrammars
            flash-nvim
            vim-sandwich
            inputs.yui.packages.${pkgs.system}.neovim

            # optional
            vim-repeat
            render-markdown-nvim
            vim-indent-object
            nvim-treesitter-context
            vim-rhubarb
            conjure
            nvim-lspconfig
            vim-dirvish
            vim-eunuch
            janet-vim
            # lightline-vim
            # nvim-treesitter-textobjects

          ];
        };
      };
    };
}
