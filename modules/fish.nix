{ pkgs
, config
, nix-env-fish
, lucid-fish-prompt
, ...
}:
let
  # These options are set by home manager programs.fzf
  # https://github.com/rycee/home-manager/blob/master/modules/programs/fzf.nix#blob-path
  # It's pointless to use home manager programs.fzf if I'm setting these anyway
  fishConfig = ''
    set -x FZF_DEFAULT_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'
    set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --no-color'
    set -x FZF_CTRL_T_OPTS "--preview '${pkgs.bat}/bin/bat {}'"
    set -x FZF_CTRL_T_COMMAND '${pkgs.fd}/bin/fd -L $dir --type f 2> /dev/null'

    bind \cb edit_command_buffer

    set -x MANPAGER 'nvim +Man!'

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go
    set -x GOCACHE $XDG_CACHE_HOME/go-build

    fish_add_path -p ~/bin /usr/local/bin/

    # https://discourse.nixos.org/t/how-is-nix-path-managed-regarding-nix-channel/6079/3?u=cidem
    set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

    abbr -a g 'git'
    abbr -a dc 'docker compose'

    source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings
  '';

in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    functions = {
      gi = {
        description = "Pick commit for interactive rebase";
        body = ''
          set -l commit (git log --pretty=oneline | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gf = {
        description = "Fixup a commit then autosquash";
        body = ''
          set -l commit (git log --pretty=oneline | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
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
        src = nix-env-fish;
      }

      {
        name = "lucid";
        src = lucid-fish-prompt;
      }
    ];
  };
}
