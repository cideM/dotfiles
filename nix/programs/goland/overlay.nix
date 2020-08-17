{ pkgs, sources, ... }:
final: prev:

{
  jetbrains = prev.jetbrains // {
    goland = prev.jetbrains.goland.overrideDerivation (_: rec {
      src = sources.goland;
    });
  };
}
