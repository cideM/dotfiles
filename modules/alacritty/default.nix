{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    settings = {
      import = [
        "${pkgs.yui-alacritty-theme}/yui.yml"
      ];
      font = (import ./fonts.nix).monaspace;
      key_bindings = [
        {
          action = "SpawnNewInstance";
          key = "N";
          mods = "Control|Alt";
        }
        {
          chars = "\\x1b\\x76";
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
          key = "Minus";
          mods = "Command|Shift";
        }
        {
          action = "DecreaseFontSize";
          key = "Minus";
          mods = "Control|Shift";
        }
        {
          action = "ResetFontSize";
          key = "Key0";
          mods = "Command|Shift";
        }
        {
          action = "ResetFontSize";
          key = "Key0";
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
          chars = "`'";
          key = "Apostrophe";
          mods = "Command";
        }
        {
          chars = "`;";
          key = "Semicolon";
          mods = "Command";
        }
        # FZF: CMD+T -> CTRL+T to find a file
        {
          chars = "\\x14";
          key = "T";
          mods = "Command";
        }
        # FZF: CMD+G -> ALT+C to cd into the selected directory
        {
          chars = "\\x1bc";
          key = "G";
          mods = "Command";
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
        args = ["-l"];
        program = "${pkgs.fish}/bin/fish";
      };
    };
  };
}
