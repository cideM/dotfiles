{ pkgs, ... }:

let
  shared = import ../../shared.nix;

  sources = import ../../nix/sources.nix;

  clojure = import ../../languages/clojure/default.nix;

  programs = import ../../programs/default.nix;

  pkgs = import sources.nixpkgs {};

  pkgs-release = import sources."nixos-20.03" {};

  operatorMono = pkgs.stdenv.mkDerivation {
    name = "operator-mono-font";
    src = builtins.path { name = "operator-mono-src"; path = (builtins.getEnv "HOME") + "/OperatorMono"; };
    buildPhases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts/operator-mono
      cp -R "$src" "$out/share/fonts/operator-mono"
    '';
  };

in {
  imports = [
    programs.nvim.config
    programs.fish.config
    programs.redshift.config
    clojure.config
    programs.fzf.config
    programs.git.config
    programs.tmux.config
  ];

  nixpkgs.overlays = [
    (import ../../programs/vscode/overlay.nix)
    (import ../../programs/neovim/overlay.nix)
  ];

  nixpkgs.config = import ../../nixpkgs_config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../../nixpkgs_config.nix;

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
  ];

  fonts.fontconfig.enable = true;

  # TODO: Extract programs below into own folders in programs/

  # On first install this needs to be disabled for allowUnfree to work. I
  # shouldn't have to do this but nothing in
  # https://github.com/rycee/home-manager/issues/463 works
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.vscode.enable = true;

  programs.direnv.enable = true;
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.yml".source = (import ../../programs/alacritty/default.nix).nixos;

  # services.lorri.enable = true;
  # Also not yet in 20.03 haiz
  # services.lorri.package = pkgs.lorri;

  programs.home-manager = {
    enable = true;
  };

  home.stateVersion = "20.03";
}
