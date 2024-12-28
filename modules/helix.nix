args @ {
  config,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        indent-guides = {
          render = true;
          character = "╎";
        };
      };
    };
  };
}
