{ pkgs, sources, ... }:
let
  overlay = final: prev:
    {
      jetbrains = prev.jetbrains // {
        goland = prev.jetbrains.goland.overrideDerivation (_: rec {
          src = sources.goland;
        });
      };
    };
in
{
  nixpkgs.overlays = [
    overlay
  ];

  home.packages = with pkgs; [
    jetbrains.goland
  ];
}
