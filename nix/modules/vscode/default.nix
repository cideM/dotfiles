{ pkgs, ... }:
let
  sources = import ./nix/sources.nix;

in
{
  programs.vscode.enable = true;

  programs.vscode = {
    enable = true;

    package = pkgs.vscode.override {
      isInsiders = true;
    }.overrideAttrs
      (_: rec {
        src = sources.vscode;
      });
  };
}
