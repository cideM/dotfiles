{ pkgs, config, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  version = "latest";


in
{
  programs.vscode = {
    enable = true;

    package = (pkgs.vscode.override {
      isInsiders = true;
    }).overrideAttrs
      (_: rec {
        # I couldn't find links to download specific versions of the insiders
        # release. There appears to be only the 'latest' version of it. This
        # confuses 'niv', since it won't update the hash if the link never
        # changes. When Nix then downloads the source, it sees a different
        # hash. Long story short: I'll just have to update the hash here all
        # the time and can't use 'niv' for this.
        src = builtins.fetchurl {
          name = "VSCode_${version}_${plat}.${archive_fmt}";
          url = "https://vscode-update.azurewebsites.net/${version}/${plat}/insider";
          sha256 = "0ys35k63c5npn30xich5787dks2pspa872ma1k7jkf9dzj75cxz8";
        };
      });
  };
}
