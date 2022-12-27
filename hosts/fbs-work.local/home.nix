{ pkgs, home-manager, config, ... }:
{
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
  ];

  programs.man.enable = true;

  programs.alacritty.enable = true;
  programs.alacritty.settings.font.size = 14;

  home.stateVersion = "20.09";

  programs.fish.interactiveShellInit = ''
    fish_add_path /opt/local/bin /opt/local/sbin

    contains "/Users/fbs/.nix-profile/share/man" $MANPATH
    or set -p MANPATH "/Users/fbs/.nix-profile/share/man"
  '';

  home.sessionVariables = pkgs.lib.attrsets.optionalAttrs config.programs.alacritty.enable {
    TERMINFO_DIRS = "${pkgs.alacritty.terminfo.outPath}/share/terminfo";
  };

  home.packages = with pkgs; [
    (
      (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
        src = (builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=darwin-arm64";
          sha256 = "063ghqhp3mmfm1dsn28d4275nh2qgpk6nsayjlrs14x6vmpn01kr";
        });
        version = "latest";
      })
    )

    nixVersions.stable
    unixtools.watch
    home-manager.defaultPackage.aarch64-darwin
    operatorMonoFont
  ];

  # https://github.com/nix-community/home-manager/issues/2942
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  xdg.configFile.".gemrc".text = ''
    :ipv4_fallback_enabled: true
  '';

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  xdg.configFile."nix/registry.json".text =
    builtins.toJSON {
      version = 2;
      flakes = pkgs.lib.attrValues config.common.flake_registries;
    };

  home.file.".gitignore".text = ''
    .direnv/
  '';

  # Can't use programs.git because https://github.com/NixOS/nixpkgs/issues/62353
  xdg.configFile."git/config".text = ''
    [alias]
        lola = log --graph --decorate --pretty=oneline --abbrev-commit --all
        recent = branch --sort=-committerdate
        unpushed = log --branches --not --remotes --no-walk --decorate --oneline
        s = status -s
        a = add
        co = commit
        ch = checkout
        b = branch
        cb = rev-parse --abbrev-ref HEAD
        dd = diff
        ds = diff --staged
        pl = pull
        ps = push

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
        pager = delta

    [interactive]
        diffFilter = delta --color-only

    [delta]
        navigate = true
        side-by-side = true
        syntax-theme = "GitHub"

    [filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true
  '';

  fonts.fontconfig.enable = true;

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
  '';
}
