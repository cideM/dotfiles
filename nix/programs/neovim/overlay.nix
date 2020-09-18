{ pkgs, sources, ... }:

final: prev:

{
  wrapNeovim = pkgs.wrapNeovim;

  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "master";
    src = sources.neovim;
  });
}
