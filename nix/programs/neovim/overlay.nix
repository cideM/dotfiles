{ pkgs, sources, ...}:

final: prev:

{
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "master";
    src = sources.neovim;
  });
}
