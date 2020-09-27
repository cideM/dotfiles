{ pkgs, ... }:

{
  # https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
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
  # This adds the fish shell hook to programs.fish.shellInit
  # https://github.com/rycee/home-manager/blob/master/modules/programs/direnv.nix#blob-path
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.home-manager = {
    enable = true;
  };

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];

  home.stateVersion = "20.03";

  fonts.fontconfig.enable = true;
}
