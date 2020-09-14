let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      # (import ./programs/anki/overlay.nix)
    ];
  };

  sharedPkgs = with pkgs; [
    aerc
    awscli
    bandwhich
    bash_5
    bat
    coreutils
    curl
    dhall
    dhall-lsp-server
    dive
    docker-compose
    du-dust
    emacs
    entr
    exa
    fd
    findutils
    fzf
    gawk
    gitAndTools.hub
    gnugrep
    gnupg
    google-cloud-sdk
    gzip
    hack-font
    haskellPackages.brittany
    hexyl
    htop
    hyperfine
    jq
    jrnl
    kubernetes-helm
    lazygit
    libuv
	luajitPackages.luacheck
    nano
    ncdu
    neofetch
    niv
    nixpkgs-fmt
    nodePackages_latest.purescript-language-server
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
    sd
    shellcheck
    shfmt
    stow
    tig
    time
    tldr
    tokei
    tree
    universal-ctags
    vim
    weechat
    wget
    yamllint
  ];

  sharedLinux = with pkgs; [
    iotop
    xclip
    feh
    escrotum
    kanji-stroke-order-font
    source-han-sans-japanese
    source-han-serif-japanese
    iosevka
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
    home.extraOutputsToInstall = [ "man" "share" "icons" "doc" ];

    home.stateVersion = "20.03";

    fonts.fontconfig.enable = true;
  };

in {
  pkgs = sharedPkgs;
  pkgsLinux = sharedLinux;
  inherit sharedSettings;
}
