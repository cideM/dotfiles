{ pkgs
, config
, nix-env-fish
, lucid-fish-prompt
, ...
}:
let
  alacCfg = config.programs.alacritty;

  # These options are set by home manager programs.fzf
  # https://github.com/rycee/home-manager/blob/master/modules/programs/fzf.nix#blob-path
  # It's pointless to use home manager programs.fzf if I'm setting these anyway
  fishConfig = ''
    set -x FZF_DEFAULT_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'
    set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --no-color'
    set -x FZF_CTRL_T_OPTS "--preview '${pkgs.bat}/bin/bat {}'"
    set -x FZF_ALT_C_OPTS "--preview 'tree -a -C {} | head -200'"
    set -x FZF_CTRL_T_COMMAND '${pkgs.fd}/bin/fd -L $dir --type f 2> /dev/null'

    set -x FISH_NOTES_EXTENSION .md
    set -x MANPAGER 'nvim +Man!'

    # The ❯ looks super weird on my linux machine
    set -x lucid_prompt_symbol '$'

    # COLORS
    # https://github.com/fish-shell/fish-shell/issues/4695
    # https://fishshell.com/docs/2.0/index.html
    # $ set | rg color
    # $ set_color -c
    # $ nix-shell -p gettext
    # $ msgcat --color=test

    # Background of tab completion and matched part in history
    set fish_color_search_match --background=yellow

    set fish_pager_color_prefix normal --bold
    set fish_pager_color_description normal
    set fish_pager_color_progress normal

    # https://github.com/fish-shell/fish-shell/issues/5527
    set fish_color_match normal --underline

    set fish_color_comment --italics
    set fish_color_command magenta
    set fish_color_quote green
    set fish_color_error red --bold

    ${if alacCfg.light then ''
      set fish_color_cwd brblack
      # telescope vim is bit buggy and will call bat with `bat --theme Monokai
      # Extended Light` which obviously doesn't work
      set -x BAT_THEME "OneHalfLight"
    '' else ''
      set fish_color_cwd white
    ''}

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go

    set -x PATH ~/bin $PATH

    # https://discourse.nixos.org/t/how-is-nix-path-managed-regarding-nix-channel/6079/3?u=cidem
    set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

    abbr -a g 'git'
    abbr -a dc ${if pkgs.stdenv.isDarwin then "'docker compose'" else "'docker-compose'"}
    abbr -a tf 'terraform'

    alias dash 'dash -E'

    source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings
  '';

in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    functions = {
      gocheck = {
        description = "Recompile on change";
        body = ''
          set exist
          for dir in "cmd" "internal" "pkg"
            if test -d $dir
                set -a exist ./$dir/...
            end
          end
          ${pkgs.fd}/bin/fd -e go | ${pkgs.entr}/bin/entr -sc "go build $exist"
        '';
      };

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

      gu = {
        description = "Update master and rebase current branch onto master";
        body = ''
          set -l default (git symbolic-ref refs/remotes/origin/HEAD | xargs basename)
          if test -n "$default"
            git fetch origin $default:$default
            git rebase $default
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
