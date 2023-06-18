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
    (import ../../modules/vim.nix)
  ];

  programs.man.enable = true;

  programs.alacritty.enable = true;
  programs.alacritty.settings.font.size = 14;

  home = {
    stateVersion = "20.09";
    packages = with pkgs; [
      nixVersions.stable
      unixtools.watch
      home-manager.defaultPackage.aarch64-darwin
    ];

    file = {
      ".gitignore" = {
        text = ''
          .direnv
        '';
      };

      "/Library/Preferences/glow/glow.yml" = {
        text = ''
          # style name or JSON path (default "auto")
          style: "light"
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

  programs.fish.interactiveShellInit = ''
    fish_add_path /opt/local/bin /opt/local/sbin

    contains "/Users/fbs/.nix-profile/share/man" $MANPATH
    or set -p MANPATH "/Users/fbs/.nix-profile/share/man"
  '';

  # https://github.com/nix-community/home-manager/issues/2942
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  xdg.configFile.".gemrc".text = ''
    :ipv4_fallback_enabled: true
  '';

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  # Can't use programs.git because https://github.com/NixOS/nixpkgs/issues/62353
  xdg.configFile."git/config".text = ''
    [push]
        default = simple

    [diff]
        algorithm = histogram
        colorMoved = default

    [pull]
        rebase = true

    [merge]
        conflictStyle = diff3

    [user]
        email = yuuki@protonmail.com
        name = Florian Beeres

    [github]
        user = "yuuki@protonmail.com";

    [core]
        editor = nvim
        excludesfile = ~/.gitignore

    [filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true

    [url "git@github.com:"]
        insteadOf = https://github.com/
  '';

  fonts.fontconfig.enable = true;

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
  '';
}
