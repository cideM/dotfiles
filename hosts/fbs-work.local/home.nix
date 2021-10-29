{ pkgs, operatorMono, home-manager, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim.nix)
    # https://github.com/NixOS/nixpkgs/issues/62353
    # (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/vscode/default.nix)
  ];

  programs.man.enable = true;

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.alacritty.terminfo.outPath}/share/terminfo";
  };

  home.stateVersion = "20.09";

  programs.fish.interactiveShellInit = ''
    fish_add_path /opt/local/bin /opt/local/sbin

    contains "/Users/fbs/.nix-profile/share/man" $MANPATH
    or set -p MANPATH "/Users/fbs/.nix-profile/share/man"
  '';

  home.packages = with pkgs; [
    nixUnstable
    unixtools.watch

    (if pkgs.stdenv.hostPlatform.system == "aarch64-darwin"
    then home-manager.defaultPackage.aarch64-darwin
    else home-manager.defaultPackage.x86_64-darwin)

    (pkgs.stdenv.mkDerivation {
      name = "operator-mono-font";
      src = operatorMono;
      buildPhases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/share/fonts/operator-mono
        cp -R "$src" "$out/share/fonts/operator-mono"
      '';
    })
  ];

  # Install through casks for Alacritty.app etc
  programs.alacritty = {
    light = true;
    font = "mono";
    enable = true;
    fontSize = 14;
  };

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    keep-derivations = true
    keep-outputs = true
  '';
  xdg.configFile."nix/registry.json".text =
    builtins.toJSON {
      version = 2;
      flakes = [
        {
          from = {
            id = "fbrs";
            type = "indirect";
          };
          to = {
            type = "github";
            owner = "cidem";
            repo = "nix-templates";
          };
        }
      ];
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

    [pull]
        rebase = true

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
        side-by-side = false
        syntax-theme = "GitHub"
        line-numbers = true

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
