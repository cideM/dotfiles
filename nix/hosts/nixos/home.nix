{ ... }:
let
  pkgsStable = import <nixos-20.03> { };

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
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim)
    (import ../../modules/git.nix)
    (import ../../modules/redshift.nix)
    (import ../../modules/fcitx.nix)
    (import ../../modules/tmux)
    (import ../../modules/ctags.nix)
    (import ../../modules/clojure)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedPackagesLinux.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/goland)
    (import ../../modules/vscode)
  ];

  home.packages = with pkgs; [
    pkgsStable.insomnia
    # If this doesn't match the system then things break because of some audio
    # libs it seems
    pkgsStable.spotify
    pkgsStable.zoom-us
    pkgsStable.slack
    operatorMono
    jetbrains.webstorm
    jetbrains.clion
    jetbrains.rider
    anki
    jetbrains.pycharm-professional
  ];

  # On first install this needs to be disabled for allowUnfree to work. I
  # shouldn't have to do this but nothing in
  # https://github.com/rycee/home-manager/issues/463 works
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty.enable = true;

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  xdg.mime.enable = true;

  services.lorri.enable = true;
}
