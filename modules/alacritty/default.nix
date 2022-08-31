{ lib, config, pkgs, ... }:
{
  programs.alacritty = {
    settings = {
      colors = (import ./colors.nix).oneLight;
      font = (import ./fonts.nix).mono;
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
          chars = "`|";
          key = "Backslash";
          mods = "Control";
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
