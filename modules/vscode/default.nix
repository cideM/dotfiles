{ pkgs, config, ... }:
let
  platform = if pkgs.stdenv.isDarwin then "darwin" else "linux-x64";

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
        src = builtins.fetchTarball {
          url = "https://vscode-update.azurewebsites.net/latest/${platform}/insider";
          sha256 = "0xi0zv8i4vslwyb1k5l81aff81xim915hyw2pjkyb1xqxfjs4xqb";
        };
      });
  };
}
