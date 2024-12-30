args @ {
  config,
  pkgs,
  ...
}: {
  xdg.configFile."ghostty/config".text = ''
    font-family = "Operator Mono SSm"
    font-style = Book
    font-style-italic = Book Italic
    font-style-bold-italic = Bold Italic
    font-style-bold = Bold
    font-size = 14
    adjust-cell-height = 20%
    cursor-invert-fg-bg = false
    cursor-color = red
    theme = light:primary,dark:Everblush
    window-padding-x = 10
    window-padding-balance = true
  '';
}

