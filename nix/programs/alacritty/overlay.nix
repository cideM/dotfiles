{ pkgs, ... }:

final: prev:
{
  alacritty = prev.alacritty.overrideAttrs (drv: rec {
    version = "0.5.0";
    pname = "alacritty";

    src = prev.fetchFromGitHub {
      owner = "alacritty";
      repo = pname;
      rev = "v${version}";
      sha256 = "0pn1lm0gmvwgwvvmzpsrgqfbzk52lavxz4y619dnh59f22n7625z";
    };

    cargoDeps = drv.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src;
      outputHash = "0ngixk8qh83y2b3b2d1f5cdlpmymaqy0vg4c12mhqb9vy6zrjwyc";
    });
  });
}
