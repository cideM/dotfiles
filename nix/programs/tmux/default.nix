{
  config = {
    programs.tmux = {
      enable = true;
      sensibleOnTop = false;
      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
