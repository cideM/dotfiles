{pkgs, ...}:
with pkgs; {
  home.packages = [
    bashInteractive
    bat
    coreutils-full
    curl
    du-dust
    entr
    exa
    fastmod
    fd
    findutils
    fzf
    gawk
    gh
    git-lfs
    gnugrep
    gnupg
    gnused
    gzip
    htop
    hyperfine
    jq
    oil
    nixpkgs-review
    nodePackages.vscode-langservers-extracted
    nushell
    rclone
    restic
    ripgrep
    rlwrap
    rsync
    shellcheck
    time
    tldr
    tokei
    tree
    universal-ctags
    unzip
    vis
    wget
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    VISUAL = "nvim";
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = ["info" "man" "share" "icons" "doc"];

  xdg.configFile."nix/registry.json".text = builtins.toJSON {
    version = 2;
    flakes = {
      fbrs = {
        from = {
          id = "fbrs";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "cidem";
          repo = "nix-templates";
        };
      };
    };
  };
}
