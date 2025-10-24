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

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    gc = {
      automatic = true;
      dates = "daily";
    };
  };

  home = {
    stateVersion = "20.09";
    packages = with pkgs; [
      unixtools.watch
      home-manager.packages.aarch64-darwin.default
      aerospace
    ];
    file = {
      "/Library/Preferences/glow/glow.yml" = {
        text = ''
          # style name or JSON path (default "auto")
          style: "auto"
          # show local files only; no network (TUI-mode only)
          local: true
          # mouse support (TUI-mode only)
          mouse: false
          # use pager to display markdown
          pager: false
          # word-wrap at width
          width: 80
        '';
      };
    };
  };

  programs = {
    jujutsu = {
      enable = true;
    };
    fish.interactiveShellInit = ''
      fish_add_path /opt/local/bin /opt/local/sbin

      # MacPorts
      if not contains /opt/local/share/man $MANPATH
        set --append MANPATH /opt/local/share/man
      end
    '';
  };

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
