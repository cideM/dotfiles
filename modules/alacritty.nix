{ lib, config, pkgs, ... }:
with lib;
with types;
let
  papercolor = {
    bright = {
      black = "0xbcbcbc";
      blue = "0xd75f00";
      cyan = "0x005f87";
      green = "0x008700";
      magenta = "0x8700af";
      red = "0xaf0000";
      white = "0xeeeeee";
      yellow = "0x5f8700";
    };
    cursor = {
      cursor = "0x444444";
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
      white = "0x878787";
      yellow = "0x5f8700";
    };
    primary = {
      background = "0xeeeeee";
      foreground = "0x444444";
    };
    vi_mode_cursor = {
      cursor = "0x878787";
      text = "0xeeeeee";
    };
  };

  pencil = {
    bright = {
      black = "0x212121";
      red = "0xfb007a";
      green = "0x5fd7af";
      yellow = "0xf3e430";
      blue = "0x20bbfc";
      magenta = "0x6855de";
      cyan = "0x4fb8cc";
      white = "0xf1f1f1";
    };
    normal = {
      black = "0x212121";
      red = "0xc30771";
      green = "0x10a778";
      yellow = "0xa89c14";
      blue = "0x008ec4";
      magenta = "0x523c79";
      cyan = "0x20a5ba";
      white = "0xe0e0e0";
    };
    primary = {
      background = "0xf1f1f1";
      foreground = "0x424242";
    };
  };

  oneLight = {
    primary = {
      background = "#fafafa";
      foreground = "#383a42";
    };
    cursor = {
      text = "CellBackground";
      cursor = "#526eff";
    };
    selection = {
      text = "CellForeground";
      background = "#e5e5e6";
    };
    normal = {
      black = "#696c77";
      red = "#e45649";
      green = "#50a14f";
      yellow = "#c18401";
      blue = "#4078f2";
      magenta = "#a626a4";
      cyan = "#0184bc";
      white = "#a0a1a7";
    };
  };

  gnomeLight = {
    primary = {
      foreground = "#171421";
      background = "#ffffff";
      bright_foreground = "#5e5c64";
    };

    normal = {
      black = "#171421";
      red = "#c01c28";
      green = "#26a269";
      yellow = "#a2734c";
      blue = "#12488b";
      magenta = "#a347ba";
      cyan = "#2aa1b3";
      white = "#d0cfcc";
    };

    bright = {
      black = "#5e5c64";
      red = "#f66151";
      green = "#33d17a";
      yellow = "#e9ad0c";
      blue = "#2a7bde";
      magenta = "#c061cb";
      cyan = "#33c7de";
      white = "#ffffff";
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

  itermDefault = {
    primary = {
      background = "#101421";
      foreground = "#fffbf6";
    };

    normal = {
      black = "#2e2e2e";
      red = "#eb4129";
      green = "#abe047";
      yellow = "#f6c744";
      blue = "#47a0f3";
      magenta = "#7b5cb0";
      cyan = "#64dbed";
      white = "#e5e9f0";
    };

    bright = {
      black = "#565656";
      red = "#ec5357";
      green = "#c0e17d";
      yellow = "#f9da6a";
      blue = "#49a4f8";
      magenta = "#a47de9";
      cyan = "#99faf2";
      white = "#ffffff";
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
    use_thin_strokes = pkgs.stdenv.isDarwin;
  };

  liberationMono = {
    bold = {
      family = "Liberation Mono";
      style = "Bold";
    };
    bold_italic = {
      family = "Liberation Mono";
      style = "Bold Italic";
    };
    glyph_offset = {
      x = 0;
      y = 0;
    };
    italic = {
      family = "Liberation Mono";
      style = "Italic";
    };
    normal = {
      family = "Liberation Mono";
      style = "Regular";
    };
    offset = {
      x = 0;
      y = 2;
    };
    use_thin_strokes = pkgs.stdenv.isDarwin;
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
    use_thin_strokes = pkgs.stdenv.isDarwin;
  };

in
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = papercolor;
      font = mono;
      alt_send_escape = pkgs.stdenv.isDarwin;
      key_bindings = [
        {
          action = "SpawnNewInstance";
          key = "N";
          mods = "Control|Alt";
        }
      ];
      window = {
        decorations = "full";
        dynamic_padding = true;
        dimensions = {
          columns = 90;
          lines = 50;
        };
        padding = {
          x = 10;
          y = 10;
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
  };
}
