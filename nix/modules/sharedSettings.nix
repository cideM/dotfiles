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

  programs.neovim = {
    treesitter = {
      enable = false;
      tsx.rev = "73afadbd117a8e8551758af9c3a522ef46452119";
      ts.rev = "73afadbd117a8e8551758af9c3a522ef46452119";
      yaml.rev = "258751d666d31888f97ca6188a686f36fadf6c43";
      go.rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
    };

    telescope = {
      enable = false;
      prefix = "<leader>t";
    };

    completion = {
      enable = false;
      plugin = "completion-nvim";
    };
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
}
