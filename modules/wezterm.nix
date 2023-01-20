{ pkgs, ... }:

{
  home.packages = [
    pkgs.wezterm
  ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    return {
      color_scheme = "Edge Light (base16)",
      default_prog = { '${pkgs.fish}/bin/fish', '-l' },
      font_size = 14.0,
      font = wezterm.font('Operator Mono SSm', { weight = 'Book' }),
      line_height = 1.1,
      keys = {
        {
          key = 'w',
          mods = 'CMD',
          action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
          key = '-',
          mods = 'CMD',
          action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
        },
        {
          key = '|',
          mods = 'CMD|SHIFT',
          action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
        },
      },
    }
  '';

}
