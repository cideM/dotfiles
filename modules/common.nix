{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    alejandra
    bashInteractive
    bat
    coreutils-full
    curl
    du-dust
    anki-bin
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
    helix
    htop
    hyperfine
    jq
    tldr
    luajitPackages.luacheck
    # broken on Darwin because of the Zig it uses?
    # ncdu
    nixpkgs-fmt
    nixpkgs-review
    nodePackages.vscode-langservers-extracted
    rclone
    restic
    ripgrep
    rlwrap
    rsync
    shellcheck
    stylua
    sumneko-lua-language-server
    time
    tokei
    tree
    universal-ctags
    unzip
    vim
    volta
    wezterm
    wget
  ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    return {
      color_scheme = "Edge Light (base16)",
      default_prog = { '${pkgs.fish}/bin/fish', '-l' },
      font_size = 15.0,
      -- font = wezterm.font('Operator Mono SSm', { weight = 'Book' }),
      line_height = 1.1,
      keys = {
        {
          key = 'w',
          mods = 'CMD',
          action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
          key = '-',
          mods = 'CMD',
          action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
        },
        {
          key = '|',
          mods = 'CMD|SHIFT',
          action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
        },
      },
    }
  '';

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
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];
}

