# A second, fully independent Neovim exposed as the `n2` command.
#
# It reuses the *same* neovim package as the main `programs.neovim` config
# (the nightly overlay), so the editor version is identical, but it has its
# own Nix-managed plugin set and its own init (./n2-init.lua). Because
# `programs.neovim` is a singleton in Home Manager, this one is wrapped by
# hand with the same machinery Home Manager uses internally.
{ inputs, ... }:
{
  flake.modules.homeManager.nvim2 =
    { pkgs, ... }:
    let
      nvimPkg = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Wrap the nightly directly with its own plugins + init.lua. The config
      # is pure Lua, so it goes straight into `luaRcContent`.
      wrapped = pkgs.wrapNeovimUnstable nvimPkg {
        withPython3 = false;
        withRuby = false;
        withNodeJs = false;

        # A Nix-managed plugin set, independent of your main nvim. Add freely.
        plugins = with pkgs.vimPlugins; [
          vim-fugitive
          nvim-lspconfig
          vim-dirvish
          fzf-lua
        ];

        luaRcContent = builtins.readFile ./n2-init.lua;
      };
    in
    {
      # The wrapper's binary is `nvim`; expose it as `n2` and give it its own
      # state dir (~/.config/n2, ~/.local/{share,state}/n2) via NVIM_APPNAME so
      # shada/swap/undo never collide with your main nvim.
      home.packages = [
        (pkgs.writeShellScriptBin "n2" ''
          export NVIM_APPNAME=n2
          exec ${wrapped}/bin/nvim "$@"
        '')
      ];
    };
}
