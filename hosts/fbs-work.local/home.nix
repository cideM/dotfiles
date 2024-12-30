{
  pkgs,
  home-manager,
  config,
  ...
}: {
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
    (import ../../modules/git.nix)
    (import ../../modules/vim.nix)
    (import ../../modules/helix.nix)
    (import ../../modules/ghostty.nix)
  ];

  programs.alacritty.enable = true;
  programs.alacritty.settings.font.size = 13;

  home = {
    stateVersion = "20.09";
    packages = with pkgs; [
      nixVersions.stable
      unixtools.watch
      home-manager.defaultPackage.aarch64-darwin
    ];
  };

  programs.fish.interactiveShellInit = ''
    fish_add_path /opt/local/bin /opt/local/sbin
  '';

  # https://github.com/nix-community/home-manager/issues/2942
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    sandbox = true
  '';

  home.file."bin/gsed".source = "${pkgs.gnused}/bin/sed";
  home.file."bin/gsed".executable = true;

  fonts.fontconfig.enable = true;

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
  '';
}
