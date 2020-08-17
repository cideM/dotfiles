{ pkgs, sources, ... }:
final: prev:

{
  vscode = (prev.vscode.override {
    isInsiders = true;
  }).overrideAttrs (_: rec {
    src = sources.vscode;
  });
}
