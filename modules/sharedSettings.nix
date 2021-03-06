{ pkgs, ... }:

{
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    VISUAL = "nvim";
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  nixpkgs.config = import ../nixpkgs_config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs_config.nix;

  programs.direnv.enable = true;
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.home-manager = {
    enable = true;
  };

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];

  home.stateVersion = "20.03";
}
