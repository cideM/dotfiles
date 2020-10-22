{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    escapeTime = 0;
    historyLimit = 50000;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
