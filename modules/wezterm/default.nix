{pkgs, ...}: {
  home.packages = [
    pkgs.wezterm
  ];

  xdg.configFile."wezterm/wezterm.lua".text =
    builtins.replaceStrings ["FISH_SHELL_PATH"] ["${pkgs.fish}/bin/fish"] (builtins.readFile ./config.lua);
}
