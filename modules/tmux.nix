{...}: {
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    plugins = [];
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
