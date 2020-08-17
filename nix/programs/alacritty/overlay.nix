# For some reason the outputHash is different on NixOS than on MacOS even
# though both are using the same HM and Nixpkgs channels.
{ sources, outputHash ? "17lyzcj07f0vyki3091vgjd0w8ki11sw5m8gb3bxdph1dl04rria", ... }:

final: prev:
{
  alacritty = prev.alacritty.overrideAttrs (drv: rec {
    version = "0.5.0";
    pname = "alacritty";

    src = sources.alacritty;

    cargoDeps = drv.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src outputHash;
    });
  });
}
