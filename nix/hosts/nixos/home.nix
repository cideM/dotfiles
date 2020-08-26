{ ... }:
let
  shared = import ../../shared.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      (import ../../programs/goland/overlay.nix { inherit pkgs sources; })
    ];
  };

  sources = import ../../nix/sources.nix;

  programs = import ../../programs/default.nix;

  fish = programs.fish { inherit pkgs sources; };

  clojure = (import ../../languages/clojure/default.nix) { inherit pkgs sources; };

  pkgs-release = import sources."nixos-20.03" { };

  alacritty = (programs.alacritty { inherit pkgs; });

  operatorMono = pkgs.stdenv.mkDerivation {
    name = "operator-mono-font";
    src = builtins.path { name = "operator-mono-src"; path = (builtins.getEnv "HOME") + "/OperatorMono"; };
    buildPhases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts/operator-mono
      cp -R "$src" "$out/share/fonts/operator-mono"
    '';
  };

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

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix { inherit pkgs sources; })
    (import ../../programs/vscode/overlay.nix { inherit pkgs sources; })
  ];

  home.packages = with pkgs; shared.pkgs ++ [
    iotop
    pkgs-release.insomnia
    xclip
    neofetch
    jrnl
    # If this doesn't match the system then things break because of some audio
    # libs it seems
    pkgs-release.spotify
    # TODO: Test on Arch and MacOS
    pkgs-release.zoom-us
    # TODO: Test on Arch and MacOS
    pkgs-release.slack
    operatorMono
    jetbrains.webstorm
    jetbrains.goland
    jetbrains.clion
    jetbrains.rider
    anki
    jetbrains.pycharm-professional
  ];

  # TODO: Extract programs below into own folders in programs/

  # On first install this needs to be disabled for allowUnfree to work. I
  # shouldn't have to do this but nothing in
  # https://github.com/rycee/home-manager/issues/463 works
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.vscode.enable = true;

  programs.alacritty.enable = true;
  programs.alacritty.settings = (alacritty.shared // {
    colors = alacritty.themes.spacemacsLight;
    font = {
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
      size = 12;
    };
  });

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  xdg.mime.enable = true;
   
  services.lorri.enable = true;
  services.lorri.package = pkgs.lorri;
}
