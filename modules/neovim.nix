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
          package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;

          initLua = builtins.readFile ./init.lua;

          plugins = with pkgs.vimPlugins; [
            vim-fugitive
            sad-vim
            fzf-lua
            conform-nvim
            nvim-treesitter.withAllGrammars
            vim-sandwich
            leap-nvim
            inputs.yui.packages.${pkgs.system}.neovim
            zen-mode-nvim
            snacks-nvim
            vim-repeat
            vim-indent-object
            nvim-treesitter-context
            vim-rhubarb
            gitsigns-nvim
            conjure
            nvim-lspconfig
            vim-dirvish
            vim-eunuch
            janet-vim
          ];
        };
      };
    };
}
