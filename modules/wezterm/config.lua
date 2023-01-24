local wezterm = require 'wezterm'
return {
  color_scheme = "Edge Light (base16)",
  default_prog = { 'FISH_SHELL_PATH', '-l' },
  font_size = 14.0,
  font = wezterm.font('SF Mono'),
  -- font = wezterm.font('Operator Mono SSm', { weight = 'Book', stretch = 'SemiCondensed' }),
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
