{ pkgs, sources, ... }:
{
  programs.vscode = {
    enable = true;

    package = (pkgs.vscode.override {
      isInsiders = true;
    }).overrideAttrs
      (_: rec {
        src = sources.vscode;
        # src = builtins.fetchTarball {
        #   url = "https://vscode-update.azurewebsites.net/latest/linux-x64/insider";
        #   sha256 = "k3vw63vysdy2991l5bpk5czqjim47f2h8fg50by9bapfksvj1jgv";
        # };
      });
  };
}
