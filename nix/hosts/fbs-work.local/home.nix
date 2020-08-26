{ ... }:
let
  shared = import ../../shared.nix;

  pkgs = import sources.nixpkgs { };

  programs = import ../../programs/default.nix;

  fish = programs.fish { inherit pkgs sources; };

  clojure = (import ../../languages/clojure/default.nix) { inherit pkgs sources; };

  sources = import ../../nix/sources.nix;

  alacritty = (programs.alacritty { inherit pkgs; });

  hackFont = {
    bold = {
      family = "Hack";
      style = "Bold";
    };
    bold_italic = {
      family = "Hack";
      style = "Bold Italic";
    };
    glyph_offset = {
      x = 0;
      y = 1;
    };
    italic = {
      family = "Hack";
      style = "Italic";
    };
    normal = {
      family = "Hack";
      style = "Regular";
    };
    offset = {
      x = 0;
      y = 2;
    };
    size = 13;
    use_thin_strokes = true;
  };

  monoFont = {
    bold = {
      family = "Operator Mono SSm";
      style = "Medium";
    };
    bold_italic = {
      family = "Operator Mono SSm";
      style = "Medium Italic";
    };
    glyph_offset = {
      x = 0;
      y = 1;
    };
    italic = {
      family = "Operator Mono SSm";
      style = "Book Italic";
    };
    normal = {
      family = "Operator Mono SSm";
      style = "Book";
    };
    offset = {
      x = 0;
      y = 2;
    };
    size = 12;
    use_thin_strokes = true;
  };
in
{
  imports = [
    clojure.config
    fish.config
    (import ../../modules/neovim.nix)
    programs.ctags
    (programs.nvim {
      inherit pkgs sources;
    })
    shared.sharedSettings
    (programs.pandoc { inherit sources; })
    programs.tmux.config
    # https://github.com/NixOS/nixpkgs/issues/62353
    # (programs.git.config pkgs)
  ];

  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR ~/.local/share/fish_notes
    set -x FISH_JOURNAL_DIR ~/.local/share/fish_journal

    contains ${pkgs.coreutils}/bin $PATH
    or set -x PATH ${pkgs.coreutils}/bin $PATH/
  '';

  home.packages = with pkgs; shared.pkgs ++ [
    lorri
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix { inherit pkgs sources; })
  ];

  # Install through casks for Alacritty.app etc
  programs.alacritty.enable = false;
  xdg.configFile."alacritty/alacritty.yml".text =
    # https://discourse.nixos.org/t/how-to-write-single-backslash/8604/2
    builtins.replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON (pkgs.lib.recursiveUpdate alacritty.shared {
      font = monoFont;

      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
    }
    ));

  # Can't use programs.git because https://github.com/NixOS/nixpkgs/issues/62353
  xdg.configFile."git/config".text = ''
    [push]
        default = simple

    [pull]
        rebase = false

    [user]
        email = yuuki@protonmail.com
        name = Florian Beeres

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
        d = diff
        pl = pull
        ps = push

    [difftool]
        prompt = false

    [difftool "nvim"]
        cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

    [mergetool]
        prompt = true

    [mergetool "nvim-merge"]
        cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

    [core]
        editor = nvim
        ignorecase = false

    [filter "lfs"]
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true
        clean = git-lfs clean -- %f

    [sendemail]
        smtpserver = 127.0.0.1
        smtpuser = yuuki@protonmail.com
        smtpencryption = starttls
        smtpserverport = 1025
  '';
}
