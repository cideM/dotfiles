{ pkgs, sources, ... }:

let

  fishConfig = ''
  set -x FZF_DEFAULT_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'
  set -x FZF_PREVIEW_FILE_CMD '${pkgs.bat}/bin/bat'
  set -x FZF_ENABLE_OPEN_PREVIEW 1
  set -x FZF_FIND_FILE_COMMAND '${pkgs.fd}/bin/fd --type f --type d --hidden 2> /dev/null'
  set -x FZF_CD_COMMAND '${pkgs.fd}/bin/fd --type d 2> /dev/null'
  set -x FZF_CD_WITH_HIDDEN_COMMAND '${pkgs.fd}/bin/fd --type d --hidden 2> /dev/null'
  set -x FZF_LEGACY_KEYBINDINGS 0

  # https://github.com/fish-shell/fish-shell/issues/3412
  # https://github.com/fish-shell/fish-shell/issues/5313
  set -u fish_pager_color_prefix 'red' '--underline'

  set -x BAT_THEME "Monokai Extended Light"

  set -x LANG en_US.UTF-8
  set -x LC_ALL en_US.UTF-8
  set -x LC_CTYPE en_US.UTF-8

  set -x GO111MODULE on

  set -x VISUAL ${pkgs.neovim}/bin/nvim
  set -x EDITOR ${pkgs.neovim}/bin/nvim

  # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
  # XDG_RUNTIME_DIR should be set by pam_systemd
  set -x XDG_CONFIG_HOME $HOME/.config
  set -x XDG_DATA_HOME $HOME/.local/share
  set -x XDG_CACHE_HOME $HOME/.cache

  set -x PATH                 \
      ~/.local/bin            \
      ~/bin                   \
      ~/.emacs.d/bin          \
      $PATH

  set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

  abbr -a pbc 'xclip -selection clipboard'
  abbr -a g 'git'
  abbr -a nsc 'notes search_content | rg body | xargs bat'
  abbr -a nst 'notes search_tags | rg body | xargs bat'
  alias fzf 'fzf --color=light'
  alias ls exa

  # opam configuration
  if test -d /home/tifa/.opam/opam-init/init.fish 
      source /home/tifa/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
  end

  # https://direnv.net/docs/hook.html
  eval (${pkgs.direnv}/bin/direnv hook fish)

  # Source hostname specific stuff
  set -l hostname_file $XDG_CONFIG_HOME/fish/(hostname).fish
  if test -e $hostname_file
      source $hostname_file
  end
  '';

  fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    package = pkgs.fish;

    functions = {
      fish_greeting = {
        body = ''
        '';
      };
    };

    promptInit = ''
      set __fish_git_prompt_show_informative_status 1

      set __fish_git_prompt_char_dirtystate '+'
      set __fish_git_prompt_char_invalidstate 'x'
      set __fish_git_prompt_char_stagedstate '*'
      set __fish_git_prompt_char_untrackedfiles 'u'
      set __fish_git_prompt_char_untrackedfiles 'u'
      set __fish_git_prompt_char_stateseparator '|'

      function fish_prompt
          set_color $fish_color_cwd
          echo -n (basename $PWD)
          fish_git_prompt
          set_color normal
          echo -n ' λ '
      end
    '';

    plugins = [
      {
        name = "nvm";
        src = sources.fish-nvm;
      }

      {
        name = "journal";
        src = sources.fish-journal;
      }

      {
        name = "yvm";
        src = sources.fish-yvm;
      }

      {
        name = "nix-env";
        src = sources.fish-nix-env;
      }

      {
        name = "fish-notes";
        src = sources.fish-notes;
      }

      {
        name = "fish-fzf";
        src = sources.fish-fzf;
      }
    ];
  };

  config = {
    programs.fish = fish;
  };

in
{
  inherit config;
}
