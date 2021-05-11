{ pkgs, config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    terminal = "${pkgs.alacritty}/bin/alacritty";
    enable = true;
    width = 1024;
    #  ~/.local/share/rofi/themes/custom.rasi
    theme = {
      "*" = {
        background-color = mkLiteral "#efeae5";
        foreground-color = mkLiteral "#635954";
        foreground-color-faded = mkLiteral "#b4aba7";
        selected-normal-foreground = mkLiteral "#5137e1";
        selected-normal-background = mkLiteral "#DCD7F9";
        selected-active-foreground = mkLiteral "#DCD7F9";
        selected-active-background = mkLiteral "#5137e1";
        border-color = mkLiteral "#b4aba7";
        width = 1024;
      };

      window = {
        background-color = mkLiteral "@background-color";
        border = 2;
        padding = 12;
      };

      mainbox = {
        spacing = 10;
      };

      inputbar = {
        spacing = 10;
      };

      prompt = {
        text-color = mkLiteral "@foreground-color-faded";
      };

      listview = {
        spacing = 5;
      };

      "element" = {
        text-color = mkLiteral "#635954";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = mkLiteral "@selected-normal-foreground";
      };

      entry = {
        text-color = mkLiteral "#635954";
      };
    };

    # This is in Xresources format. Get a list of possible values with rofi -dump-xresources
    font = "Hack 12";

    extraConfig = {
      modi = "combi,window,drun";
      combi-modi = "window,drun";
      window-format = "{c}       {t}";
    };
  };
}

