{ pkgs, ... }:
final: prev:

{
  vscode = (prev.vscode.override {
    isInsiders = true;
  }).overrideAttrs (_: rec {
    src = (builtins.fetchTarball {
      url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      sha256 = "1cf8njkgmxrsi4y31al8ppplqhchmdzp5zxqr791bv5v6s66bv5p";
    });
    version = "latest";
  });
}
