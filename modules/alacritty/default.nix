{ lib, config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = (import ./colors.nix).papercolor;
      font = (import ./fonts.nix).mono;
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
