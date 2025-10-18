{
  pkgs,
  home-manager,
  config,
  ...
}:
{
  imports = [
    (import ../../modules/neovim)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
    (import ../../modules/git.nix)
    (import ../../modules/ghostty.nix)
  ];

  programs.alacritty.enable = true;
  programs.alacritty.settings.font.size = 13;

  home = {
    stateVersion = "20.09";
    packages = with pkgs; [
      unixtools.watch
      home-manager.packages.aarch64-darwin.default
      aerospace
    ];
  };

  programs.fish.interactiveShellInit = ''
    fish_add_path /opt/local/bin /opt/local/sbin

    # MacPorts
    if not contains /opt/local/share/man $MANPATH
      set --append MANPATH /opt/local/share/man
    end
  '';

  # https://github.com/nix-community/home-manager/issues/2942
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    sandbox = false
    include /Users/fbs/.git-token
  '';

  home.file."bin/gsed".source = "${pkgs.gnused}/bin/sed";
  home.file."bin/gsed".executable = true;

  fonts.fontconfig.enable = true;
}
