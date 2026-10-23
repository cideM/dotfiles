{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with types;
let
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
    {
      config = {
        xdg.configFile = readFtPlugins ./neovim/ftplugins;

        programs.neovim = {
          enable = true;
          # The nightly's functional test suite has timing-sensitive treesitter
          # tests that flake on this machine; skip it.
          package =
            inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
              (_: {
                doCheck = false;
              });

          initLua = builtins.readFile ./init.lua;

          plugins = with pkgs.vimPlugins; [
            conform-nvim
            conjure
            diffview-nvim
            fzf-lua
            gitsigns-nvim
            inputs.yui.packages.${pkgs.system}.neovim
            janet-vim
            leap-nvim
            nvim-bufdel
            nvim-lspconfig
            nvim-treesitter-context
            nvim-treesitter.withAllGrammars
            octo-nvim
            sad-vim
            snacks-nvim
            vim-eunuch
            vim-fugitive
            vim-indent-object
            vim-repeat
            vim-rhubarb
            vim-sandwich
            zen-mode-nvim
          ];
        };
      };
    };
}
