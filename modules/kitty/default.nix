{ pkgs, ... }: {
  xdg.configFile."kitty/kitty.conf".text = ''
    font_family          Operator Mono SSm Book
    bold_font            Operator Mono SSm Medium
    italic_font          Operator Mono SSm Book Italic
    bold_italic_font     Operator Mono SSm Medium Italic
    font_size            15.0

    adjust_line_height   0
    adjust_column_width  0
    adjust_baseline      1

    enable_audio_bell    no

    foreground           #444444
    background           #eeeeee
    selection_background #ffffff
    color0               #eeeeee
    color8               #bcbcbc
    color4               #0087af
    color12              #d75f00
    color6               #005f87
    colo14               #005f87
    color2               #008700
    color10              #008700
    color5               #878787
    color13              #8700af
    color1               #af0000
    color9               #af0000
    color7               #878787
    color15              #eeeeee
    color3               #5f8700
    color11              #5f8700

    mark1_background     #cd25ff
    mark2_background     #ff943f
    mark3_background     #b6ff0b

    shell ${pkgs.fish}/bin/fish

    kitty_mod ${if pkgs.stdenv.isDarwin then "cmd" else "ctrl+shift"}

    map cmd+ctrl+m toggle_layout stack
  '';
}
