{ ... }:
let
  shared = import ../../shared.nix;

  pkgs = import sources.nixpkgs { };

  programs = import ../../programs/default.nix;

  clojure = (import ../../languages/clojure/default.nix) { inherit pkgs sources; };

  sources = import ../../nix/sources.nix;

  fish = programs.fish { inherit pkgs sources; };

  alacritty = (programs.alacritty { inherit pkgs; });

in
{
  imports = [
    (import ../../modules/neovim.nix)
    clojure.config
    fish.config
    programs.ctags
    (programs.git { inherit pkgs; })
    (programs.nvim { inherit pkgs sources; })
    shared.sharedSettings
    (programs.pandoc { inherit sources; })
    programs.redshift
    programs.tmux.config
  ];

  home.packages = with pkgs; shared.pkgs ++ [
    iotop
    xclip
    feh
    escrotum
    kanji-stroke-order-font
    source-han-sans-japanese
    source-han-serif-japanese
    iosevka
    slack
    discord
    spotify
    insomnia
    sublime-merge-dev
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix { inherit pkgs sources; })
  ];

  programs.fish.shellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  # https://github.com/rycee/home-manager/blob/master/modules/targets/generic-linux.nix#blob-path
  targets.genericLinux.enable = true;

  pam.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  home.file.".profile".text = ''
    export XDG_DATA_DIRS="/home/cloud/.nix-profile/share:$XDG_DATA_DIRS"
  '';

  programs.alacritty.enable = false;
  xdg.configFile."alacritty/alacritty.yml".text =
    builtins.replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON ( alacritty.shared // {
      colors = alacritty.themes.iceberg-light;
      font = alacritty.fonts.mono;
    }));

  services.lorri.enable = true;
  services.lorri.package = pkgs.lorri;

  xdg.mime.enable = true;

  # https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };
}
