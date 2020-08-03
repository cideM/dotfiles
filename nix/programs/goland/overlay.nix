{ pkgs, ... }:
final: prev:

{
  jetbrains = prev.jetbrains // {
    goland = prev.jetbrains.goland.overrideDerivation (_: rec {
      name = "goland-${version}";
      version = "2020.2";
      src = (builtins.fetchurl {
        url = "https://download.jetbrains.com/go/${name}.tar.gz";
        sha256 = "1hrswn7bapd68ybj3mslk1ma0rirksfca2df8byk834shm2cds40";
      });
    });
  };
}
