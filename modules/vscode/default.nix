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
          sha256 = "1kjawssh86yw7scwck1f2fw80i5ab5rc4czd1z38nlrq23a1n0c7";
        };
      });
  };
}
