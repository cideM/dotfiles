{ pkgs, ... }:
final: prev:

{
  vscode = (prev.vscode.override {
    isInsiders = true;
  }).overrideAttrs (_: rec {
    src = (builtins.fetchTarball {
      url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      sha256 = "1pilbf70lmpjy2r9z97pgx8wcw0jg55rk38py83pfb9c3zydc3b0";
    });
    version = "latest";
  });
}
