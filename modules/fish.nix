{
  pkgs,
  config,
  ...
}: let
  # These options are set by home manager programs.fzf
  # https://github.com/rycee/home-manager/blob/master/modules/programs/fzf.nix#blob-path
  # It's pointless to use home manager programs.fzf if I'm setting these anyway
  fishConfig = ''
    bind \cb edit_command_buffer

    set -x BAT_THEME 'GitHub'

    set -x MANPAGER 'nvim +Man!'

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go
    set -x GOCACHE $XDG_CACHE_HOME/go-build

    fish_add_path -p ~/bin /usr/local/bin/
  '';
in {
  programs.fish = {
    enable = true;

    shellAbbrs = {
      g = "git";
      ga = "git add";
      gb = "git branch";
      gc = "git commit -v";
      gca = "git commit -v -a";
      gcam = "git commit -v -a --amend";
      gco = "git checkout";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git log";
      gls = "git log --stat";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpl = "git pull";
      gs = "git status";
      gst = "git stash";
      gsta = "git stash apply";
      gstl = "git stash list";
      gstp = "git stash pop";
      gstc = "git stash clear";
      gstd = "git stash drop";
      dc = "docker compose";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      tf = "terraform";
      n = "nvim";
      k = "kubectl";
    };

    interactiveShellInit = fishConfig;

    functions = {
      gi = {
        description = "Pick commit for interactive rebase";
        body = ''
          set -l commit (git log --oneline --decorate | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gf = {
        description = "Fixup a commit then autosquash";
        body = ''
          set -l commit (git log --oneline --decorate | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git commit --fixup $commit
            GIT_SEQUENCE_EDITOR=true git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gc = {
        description = "fzf git checkout";
        body = ''
          git ch (git b -a --sort=-committerdate |
            fzf --preview 'git log (echo {} | sed -E -e \'s/^(\+|\*)//\' | string trim) -- ' |
            sed -E -e 's/^(\+|\*)//' |
            xargs basename |
            string trim)
        '';
      };

      fish_greeting = {
        body = ''
        '';
      };
    };

    plugins = [
      {
        name = "nix-env";
        src = pkgs.nix-fish.src;
      }

      {
        name = "lucid";
        src = pkgs.lucid-fish-prompt.src;
      }
    ];
  };
}
