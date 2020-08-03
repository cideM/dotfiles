let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      # (import ./programs/anki/overlay.nix)
    ];
  };

  sharedPkgs = with pkgs; [
    awscli
    bash_5
    bat
    coreutils
    curl
    dhall
    fzf
    haskellPackages.dhall-lsp-server
    dive
    docker-compose
    entr
    exa
    fd
    findutils
    gawk
    gitAndTools.hub
    gnugrep
    gnupg
    gzip
    hack-font
    hexyl
    htop
    jq
    go
    golangci-lint
    gopls
    jrnl
    kubernetes-helm
    lazygit
    libuv
    # Anki doesn't see this mpv and therefore refuses to play sound
    mpv
    nano
    ncdu
    neofetch
    niv
    nixpkgs-fmt
    pandoc
    perl
    ranger
    rclone
    restic
    ripgrep
    rlwrap
    roboto
    roboto-mono
    rsync
    rust-analyzer
    s3cmd
    shfmt
    shellcheck
	luajitPackages.luacheck
    stow
    tig
    tldr
    tokei
    tree
    universal-ctags
    vim
    weechat
    wget
    yamllint
  ];

  sharedSettings = {
    nixpkgs.config = import ./nixpkgs_config.nix;
    xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs_config.nix;

    programs.direnv.enable = true;
    # This adds the fish shell hook to programs.fish.shellInit
    # https://github.com/rycee/home-manager/blob/master/modules/programs/direnv.nix#blob-path
    programs.direnv.enableFishIntegration = true;
    programs.direnv.enableNixDirenvIntegration = true;

    programs.home-manager = {
      enable = true;
    };

    # https://github.com/rycee/home-manager/issues/432
    programs.man.enable = false;
    home.extraOutputsToInstall = [ "man" ];

    home.stateVersion = "20.03";

    fonts.fontconfig.enable = true;
  };

in {
  pkgs = sharedPkgs;
  inherit sharedSettings;
}
