{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix)
    # (import ../../modules/neovim)
    (import ../../modules/neovim_simple)
    (import ../../modules/git.nix)
    (import ../../modules/tmux)
    (import ../../modules/redshift.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/bspwm)
    (import ../../modules/polybar)
    (import ../../modules/rofi)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/sources.nix)
    (import ../../modules/vscode)
  ];

  sources = import ../../nix/sources.nix;

  home.packages = with pkgs; [
    iotop
    xsel
    kanji-stroke-order-font
    cachix
    source-han-sans-japanese
    source-han-serif-japanese
    flameshot
    iosevka
    kazam
    insomnia
    (import ../../derivations/kubectl.nix {
      inherit (pkgs) stdenv;
      inherit (builtins) fetchurl;
    })
    sublime-merge
    spotify
    gnupg
    zotero
    zoom-us
    mupdf
    okular
    betterlockscreen
    zathura
    delta
    slack
    discord
    anki
    jetbrains.clion
    jetbrains.rider
    jetbrains.webstorm
    nerdfonts
    android-studio
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.pycharm-professional
    skype
  ];

  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty = {
    light = true;
    disableScaling = true;
    font = "mono";
    enable = true;
    fontSize = 11;
  };

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR ~/notes_new
    set -x FISH_WORK_NOTES ~/work_notes
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';

  xresources.extraConfig = ''
    Xft.dpi: 96
  '';

  services.picom = {
    enable = true;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "500x25-30+50";
        padding = 12;
        horizontal_padding = 24;
        frame_width = 0;
        frame_color = "#b4aba7";
        font = "Hack 12";
      };
      urgency_low = {
        background = "#efeae5";
        foreground = "#635954";
        timeout = 10;
      };
      urgency_normal = {
        background = "#efeae5";
        foreground = "#635954";
        timeout = 10;
      };
      urgency_critical = {
        background = "#ffe0e0";
        foreground = "#a7111d";
        timeout = 0;
      };
    };
  };

  programs.feh.enable = true;

  xsession = {
    enable = true;

    scriptPath = ".xinitrc";

    profileExtra = ''
      # key repeat and delay
      xset r rate 200 60

      # Actual monitor DPI at home is something different but I don't like large
      # fonts and UI elements. I don't want scaling
      xrandr --dpi 96

      # Screensaver timeout
      xset s 300

      # caps to esc
      setxkbmap -option ctrl:nocaps -layout us -variant altgr-intl

      # Change cursor shape from default X
      xsetroot -cursor_name left_ptr

      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
    '';
  };
}
