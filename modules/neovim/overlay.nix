{ pkgs, ... }:

final: prev:

{
  wrapNeovim = pkgs.wrapNeovim;

  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.tree-sitter ];
  });
}
