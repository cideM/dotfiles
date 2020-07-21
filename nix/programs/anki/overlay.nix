# final: prev:
# # This doesn't work. Even though it looks like I'm doing exactly the same as
# # https://github.com/flyingcircusio/fc-nixos/blob/a1c1063c4f2205fb6385fadc53083425451af5db/pkgs/overlay-python.nix
# # https://discourse.nixos.org/t/overriding-not-being-kept/7818/2
# # https://nixos.org/nixpkgs/manual/#how-to-override-a-python-package-using-overlays
# # https://nixos.org/nixpkgs/manual/#python Talks about overridePythonAttrs
# let
#   ankiOverlay = python-final: python-prev: {
#     anki = python-prev.anki.overrideAttrs (oldAttrs: rec {
#       version = "2.1.26";
#       pname = oldAttrs.pname;
#       src = python-prev.fetchurl {
#         urls = [
#           "https://apps.ankiweb.net/downloads/current/${pname}-${version}-source.tgz"
#           # "https://apps.ankiweb.net/downloads/current/${name}-source.tgz"
#           # "http://ankisrs.net/download/mirror/${name}.tgz"
#           # "http://ankisrs.net/download/mirror/archive/${name}.tgz"
#         ];
#         sha256 = "0000000000000000000000000000000000000000000000000000";
#       };
#       # sha256-pkg = "0000000000000000000000000000000000000000000000000000";
#       # rev-manual = "8f6387867ac37ef3fe9d0b986e70f898d1a49139";
#       # sha256-manual = "0pm5slxn78r44ggvbksz7rv9hmlnsvn9z811r6f63dsc8vm6mfml";
#     });
#   };

# in
# {
#   python = prev.python.override {
#     packageOverrides = ankiOverlay;
#   };

#   python3 = prev.python3.override {
#     packageOverrides = ankiOverlay;
#   };

#   python36 = prev.python37.override {
#     packageOverrides = ankiOverlay;
#   };

#   python37 = prev.python37.override {
#     packageOverrides = ankiOverlay;
#   };

#   python38 = prev.python38.override {
#     packageOverrides = ankiOverlay;
#   };
# }
final: prev:
{
  anki = prev.anki.overrideAttrs (oldAttrs: rec {
    version = "2.1.15";
    pname = oldAttrs.pname;
    # postPatch = "";
    src = prev.fetchurl {
      urls = [
        "https://github.com/ankitects/anki/archive/${version}.tar.gz"
        # "https://apps.ankiweb.net/downloads/current/${pname}-${version}-source.tgz"
        # "https://apps.ankiweb.net/downloads/current/${name}-source.tgz"
        # "http://ankisrs.net/download/mirror/${name}.tgz"
        # "http://ankisrs.net/download/mirror/archive/${name}.tgz"
      ];
      sha256 = "1yc6rhrm383k6maq0da0hw779i00as6972jai0958m6gmj32kz0n";
    };
    # sha256-pkg = "0000000000000000000000000000000000000000000000000000";
    # rev-manual = "8f6387867ac37ef3fe9d0b986e70f898d1a49139";
    # sha256-manual = "0pm5slxn78r44ggvbksz7rv9hmlnsvn9z811r6f63dsc8vm6mfml";
  });
}
