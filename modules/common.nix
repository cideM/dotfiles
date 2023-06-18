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
    gawk
    gh
    git-lfs
    glow
    gnugrep
    gnupg
    gnused
    gzip
    htop
    hyperfine
    jq
    nixpkgs-review
    nushell
    oil
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

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [
        "-p 80%,80%"
      ];
    };
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview '${pkgs.exa}/bin/exa --oneline --git --long {}'"
      "--color=light"
    ];
    historyWidgetOptions = [
      "--sort"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range :300 {}'"
      "--color=light"
    ];
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--color=light"
    ];
  };

  programs.dircolors = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

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
