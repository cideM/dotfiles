{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    settings = {
      general = {
        import = [
          "${pkgs.yui-alacritty-theme}/alacritty/yui_light.toml"
        ];
      };
      font = (import ./fonts.nix).operatorMono;
      keyboard = {
        bindings = [
          {
            action = "SpawnNewInstance";
            key = "N";
            mods = "Control|Alt";
          }
          {
            chars = "`'";
            key = "'";
            mods = "Command";
          }
          {
            chars = "\\u0014";
            key = "T";
            mods = "Command";
          }
          # FZF: CMD+G -> ALT+C to cd into the selected directory
          {
            chars = "\\u001bc";
            key = "G";
            mods = "Command";
          }
          {
            chars = "\\u001b\\u0076";
            key = "I";
            mods = "Command";
          }
          {
            chars = "`-";
            key = "Minus";
            mods = "Control";
          }
          {
            chars = "`-";
            key = "Minus";
            mods = "Command";
          }
          {
            action = "DecreaseFontSize";
            key = "_";
            mods = "Command|Shift";
          }
          {
            action = "DecreaseFontSize";
            key = "_";
            mods = "Control|Shift";
          }
          {
            action = "ResetFontSize";
            key = ")";
            mods = "Command|Shift";
          }
          {
            action = "ResetFontSize";
            key = ")";
            mods = "Control|Shift";
          }
          {
            chars = "`|";
            key = "Backslash";
            mods = "Control";
          }
          {
            chars = "`|";
            key = "Backslash";
            mods = "Command";
          }
          {
            chars = "`x";
            key = "X";
            mods = "Control|Shift";
          }
          {
            chars = "`c";
            key = "S";
            mods = "Control";
          }
          {
            chars = "`c";
            key = "S";
            mods = "Command";
          }
          {
            chars = "`x";
            key = "X";
            mods = "Command";
          }
          {
            chars = "`0";
            key = "Key0";
            mods = "Command";
          }
          {
            chars = "`1";
            key = "Key1";
            mods = "Command";
          }
          {
            chars = "`2";
            key = "Key2";
            mods = "Command";
          }
          {
            chars = "`3";
            key = "Key3";
            mods = "Command";
          }
          {
            chars = "`4";
            key = "Key4";
            mods = "Command";
          }
          {
            chars = "`5";
            key = "Key5";
            mods = "Command";
          }
          {
            chars = "`;";
            key = "Semicolon";
            mods = "Command";
          }
          # FZF: CMD+T -> CTRL+T to find a file
        ];
      };
      window = {
        option_as_alt = "OnlyLeft";
        decorations = "full";
        dynamic_padding = true;
        dimensions = {
          columns = 90;
          lines = 50;
        };
        padding = {
          x = 20;
          y = 20;
        };
      };
      env = {
        TERM = "alacritty";
      };
      terminal = {
        shell = {
          args = ["-l"];
          program = "${pkgs.fish}/bin/fish";
        };
      };
    };
  };
}
