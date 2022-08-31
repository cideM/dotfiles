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
    set -x FZF_ALT_C_OPTS "--preview 'tree -a -C {} | head -200'"
    set -x FZF_CTRL_T_COMMAND '${pkgs.fd}/bin/fd -L $dir --type f 2> /dev/null'

    bind \cb edit_command_buffer

    set -x MANPAGER 'nvim +Man!'
    set -x lucid_prompt_symbol '$'

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
    abbr -a dc ${if pkgs.stdenv.isDarwin then "'docker compose'" else "'docker-compose'"}
    abbr -a tf 'terraform'

    alias dash 'dash -E'

    source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings

    # https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_day.fish
    # TokyoNight Color Palette
    set -l foreground 3760bf
    set -l selection 99a7df
    set -l comment 848cb5
    set -l red f52a65
    set -l orange b15c00
    set -l yellow 8c6c3e
    set -l green 587539
    set -l purple 7847bd
    set -l cyan 007197
    set -l pink 9854f1

    # Syntax Highlighting Colors
    set -g fish_color_normal $foreground
    set -g fish_color_command $cyan
    set -g fish_color_keyword $pink
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_end $orange
    set -g fish_color_error $red
    set -g fish_color_param $purple
    set -g fish_color_comment $comment
    set -g fish_color_selection --background=$selection
    set -g fish_color_search_match --background=$selection
    set -g fish_color_operator $green
    set -g fish_color_escape $pink
    set -g fish_color_autosuggestion $comment

    # Completion Pager Colors
    set -g fish_pager_color_progress $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment
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
