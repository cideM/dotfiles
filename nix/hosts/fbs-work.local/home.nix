# Lots of things are commented out because right now I don't want to have half
# of my programs coming from pacman and the other half from home manager
{ pkgs, ... }:
let
  shared = import ../../shared.nix;

  programs = import ../../programs/default.nix;

  clojure = import ../../languages/clojure/default.nix;

  sources = import ../../nix/sources.nix;

  pkgs = import sources.nixpkgs { };

in
{
  imports = [
    programs.nvim.config
    programs.fish.config
    clojure.config
    programs.fzf.config
    programs.tmux.config
    # https://github.com/NixOS/nixpkgs/issues/62353
    # programs.git.config
  ];

  home.packages = with pkgs; shared.pkgs ++ [
    neofetch
    jrnl
    gitAndTools.delta
    lorri
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix)
  ];

  nixpkgs.config = import ../../nixpkgs_config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../../nixpkgs_config.nix;

  xdg.configFile."fish/fbs-work.local.fish" = {
    text = ''
      set -x SHELL ${pkgs.fish}/bin/fish

      contains /usr/local/opt/coreutils/libexec/gnubin $PATH
      or set -x PATH /usr/local/opt/coreutils/libexec/gnubin $PATH/

      contains /opt/local/bin $PATH
      or set -x PATH /opt/local/bin $PATH
    '';
  };

  programs.alacritty.enable = true;
  # xdg.configFile."alacritty/alacritty.yml".source = (import ../../programs/alacritty/default.nix).macos;

  programs.fzf.enable = true;

  programs.direnv.enable = true;

  programs.alacritty.settings = {
    colors = {
      primary = {
        background = "0xeeeeee";
        foreground = "0x878787";
      };

      normal = {
        black = "0xeeeeee"; red = "0xaf0000";
        green = "0x008700";
        yellow = "0x5f8700";
        blue = "0x0087af";
        magenta = "0x878787";
        cyan = "0x005f87";
        white = "0x444444";
      };

      # Bright colors
      bright = {
        black = "0xbcbcbc";
        red = "0xd70000";
        green = "0xd70087";
        yellow = "0x8700af";
        blue = "0xd75f00";
        magenta = "0xd75f00";
        cyan = "0x005faf";
        white = "0x005f87";
      };
    };
    shell = {
      args = [ "-l" ];
      program = "${pkgs.fish}/bin/fish";
    };
    env = {
      TERM = "alacritty";
    };
    font = {
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
        y = 2;
      };
      italic = {
        family = "Operator Mono SSm";
        style = "Light Italic";
      };
      normal = {
        family = "Operator Mono SSm";
        style = "Light";
      };
      offset = {
        x = 0;
        y = 4;
      };
      size = 12;
      use_thin_strokes = true;
    };
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
      padding = {
        x = 10;
        y = 10;
      };
      position = {
        x = 0;
        y = 0;
      };
      startup_mode = "Windowed";
    };
  };

  programs.home-manager = {
    enable = true;
  };

  home.stateVersion = "20.03";
}
