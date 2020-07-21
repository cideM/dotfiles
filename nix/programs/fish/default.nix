let
  sources = import ../../nix/sources.nix;

  pkgs = import sources.nixpkgs {};

  fishConfig = builtins.readFile ./config.fish;

  fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    package = pkgs.fish;

    functions = {
      fish_greeting = {
        body = ''
        '';
      };

      agenda = {
        body = ''
          $EDITOR (dirname (rg --files-with-matches -wF '#TODO#' $FISH_NOTES_DIR/*/title))/body*
        '';
      };

      agenda_work = {
        body = ''
          $EDITOR (dirname (rg --files-with-matches -wF '#TODO_WORK#' $FISH_NOTES_DIR/*/title))/body*
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
    ];
  };

  config = {
    programs.fish = fish;
  };

in {
  inherit config;
}
