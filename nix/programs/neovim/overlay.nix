final: prev:

let
  sources = import ../../nix/sources.nix;

  pkgs = sources.nixpkgs;

in {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "master";
    src = sources.neovim;
  });
}
