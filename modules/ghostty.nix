args @ {
  config,
  pkgs,
  ...
}: {
  xdg.configFile."ghostty/themes/yui_dark".text = builtins.readFile "${pkgs.yui-ghostty-theme}/ghostty/yui_dark";
  xdg.configFile."ghostty/themes/yui_light".text = builtins.readFile "${pkgs.yui-ghostty-theme}/ghostty/yui_light";
  xdg.configFile."ghostty/config".text = ''
    font-family = "Operator Mono SSm"
    font-style = Book
    font-style-italic = Book Italic
    font-style-bold-italic = Bold Italic
    font-style-bold = Bold
    font-size = 15
    font-thicken = true
    font-thicken-string = 50
    shell-integration-features = no-cursor
    adjust-cell-height = 10%
    adjust-cell-width = -5%
    cursor-invert-fg-bg = false
    cursor-style = block
    cursor-color = red
    macos-titlebar-style = transparent
    minimum-contrast = 1.1
    theme = light:yui_light,dark:yui_dark
    window-padding-x = 14
    window-padding-balance = true
    font-codepoint-map = U+00A4-U+00F7,U+03B7-U+03C4,U+2045-U+2099,U+2102,U+2198-U+2369,U+25A1-U+25FF,U+266D-U+2682,U+27DC,U+2919-U+2938,U+29B7-U+2A2C,U+2B1A=Uiua386
  '';
}
