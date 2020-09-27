{ pkgs, ... }:
let
  papercolor = {
    bright = {
      black = "0xbcbcbc";
      blue = "0xd75f00";
      cyan = "0x005faf";
      green = "0xd70087";
      magenta = "0xd75f00";
      red = "0xd70000";
      white = "0x005f87";
      yellow = "0x8700af";
    };
    cursor = {
      cursor = "0x878787";
      text = "0xeeeeee";
    };
    indexed_colors = [ ];
    normal = {
      black = "0xeeeeee";
      blue = "0x0087af";
      cyan = "0x005f87";
      green = "0x008700";
      magenta = "0x878787";
      red = "0xaf0000";
      white = "0x444444";
      yellow = "0x5f8700";
    };
    primary = {
      background = "0xeeeeee";
      foreground = "0x878787";
    };
    vi_mode_cursor = {
      cursor = "0x878787";
      text = "0xeeeeee";
    };
  };

  spacemacsLight = {
    primary = {
      foreground = "#64526F";
      background = "#FAF7EE";
    };

    cursor = {
      cursor = "#64526F";
      text = "#FAF7EE";
    };
    normal = {
      black = "#FAF7EE";
      red = "#DF201C";
      green = "#29A0AD";
      yellow = "#DB742E";
      blue = "#3980C2";
      magenta = "#2C9473";
      cyan = "#6B3062";
      white = "#64526F";
    };

    bright = {
      black = "#9F93A1";
      red = "#DF201C";
      green = "#29A0AD";
      yellow = "#DB742E";
      blue = "#3980C2";
      magenta = "#2C9473";
      cyan = "#6B3062";
      white = "#64526F";
    };
  };

  iceberg-light = {
    primary = {
      background = "0xe8e9ec";
      foreground = "0x33374c";
    };

    normal = {
      black = "0xdcdfe7";
      red = "0xcc517a";
      green = "0x668e3d";
      yellow = "0xc57339";
      blue = "0x2d539e";
      magenta = "0x7759b4";
      cyan = "0x3f83a6";
      white = "0x33374c";
    };

    bright = {
      black = "0x8389a3";
      red = "0xcc3768";
      green = "0x598030";
      yellow = "0xb6662d";
      blue = "0x22478e";
      magenta = "0x6845ad";
      cyan = "0x327698";
      white = "0x262a3f";
    };
  };

  iceberg = {
    primary = {
      background = "#161821";
      foreground = "#d2d4de";
    };

    normal = {
      black = "#161821";
      red = "#e27878";
      green = "#b4be82";
      yellow = "#e2a478";
      blue = "#84a0c6";
      magenta = "#a093c7";
      cyan = "#89b8c2";
      white = "#c6c8d1";
    };

    bright = {
      black = "#6b7089";
      red = "#e98989";
      green = "#c0ca8e";
      yellow = "#e9b189";
      blue = "#91acd1";
      magenta = "#ada0d3";
      cyan = "#95c4ce";
      white = "#d2d4de";
    };
  };

  mono = {
    bold = {
      family = "Operator Mono SSm";
      style = "Medium";
    };
    bold_italic = {
      family = "Operator Mono SSm";
      style = "Medium Italic";
    };
    glyph_offset = {
      x = 0;
      y = 1;
    };
    italic = {
      family = "Operator Mono SSm";
      style = "Book Italic";
    };
    normal = {
      family = "Operator Mono SSm";
      style = "Book";
    };
    offset = {
      x = 0;
      y = 2;
    };
    size = 12;
    use_thin_strokes = true;
  };

  dejavuSansMono = {
    bold = {
      family = "DejaVu Sans Mono";
      style = "Bold";
    };
    bold_italic = {
      family = "DejaVu Sans Mono";
      style = "Bold Oblique";
    };
    glyph_offset = {
      x = 0;
      y = 1;
    };
    italic = {
      family = "DejaVu Sans Mono";
      style = "Oblique";
    };
    normal = {
      family = "DejaVu Sans Mono";
      style = "Book";
    };
    offset = {
      x = 0;
      y = 2;
    };
    size = 12;
    use_thin_strokes = true;
  };

  hack = {
    bold = {
      family = "Hack";
      style = "Bold";
    };
    bold_italic = {
      family = "Hack";
      style = "Bold Italic";
    };
    glyph_offset = {
      x = 0;
      y = 1;
    };
    italic = {
      family = "Hack";
      style = "Italic";
    };
    normal = {
      family = "Hack";
      style = "Regular";
    };
    offset = {
      x = 0;
      y = 2;
    };
    size = 13;
    use_thin_strokes = true;
  };

  shared = {
    colors = spacemacsLight;

    key_bindings = [
      {
        chars = "`";
        key = "P";
        mods = "Alt";
      }
      {
        chars = "` ";
        key = "N";
        mods = "Alt";
      }
      # https://discourse.nixos.org/t/how-to-write-single-backslash/8604
      {
        chars = "\\u001bo";
        key = "O";
        mods = "Alt";
      }
      {
        chars = "\\u001bO";
        key = "O";
        mods = "Shift|Alt";
      }
      {
        chars = "\\u001b0";
        key = "Key0";
        mods = "Alt";
      }
      {
        chars = "\\u001bl";
        key = "L";
        mods = "Alt";
      }
      {
        chars = "\\u001bh";
        key = "H";
        mods = "Alt";
      }
      {
        chars = "\\u001bk";
        key = "K";
        mods = "Alt";
      }
      {
        chars = "\\u001bj";
        key = "J";
        mods = "Alt";
      }
      {
        chars = "`c";
        key = "S";
        mods = "Control|Shift";
      }
      {
        chars = "`x";
        key = "X";
        mods = "Control|Shift";
      }
      {
        chars = "`-";
        key = "Subtract";
        mods = "Control";
      }
      {
        chars = "`-";
        key = "Minus";
        mods = "Control";
      }
      {
        chars = "`|";
        key = "Backslash";
        mods = "Control";
      }
      {
        chars = "`z";
        key = "Grave";
        mods = "Control";
      }
      {
        action = "SpawnNewInstance";
        key = "N";
        mods = "Control|Alt";
      }
      {
        action = "None";
        key = "Minus";
        mods = "Control";
      }
      {
        action = "None";
        key = "Subtract";
        mods = "Control";
      }
    ];

    window = {
      dynamic_padding = true;
      padding = {
        x = 40;
        y = 40;
      };
    };

    env = {
      TERM = "alacritty";
    };

    shell = {
      args = [ "-l" ];
      program = "${pkgs.fish}/bin/fish";
    };
  };
in
{
  xdg.configFile."alacritty/alacritty.yml".text =
    builtins.replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON (shared // {
      colors = spacemacsLight;
      font = hack;
    }));
}