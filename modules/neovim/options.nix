{ config, lib, pkgs, ... }:

with lib;
with types;
let

  grammarConfigModule = submodule {
    options = {
      rev = mkOption {
        type = str;
        description = ''
          Git revision to fetch for this grammar (copy & paste the Git sha)
        '';
      };

    };
  };

in
{
  options.programs.neovim.clojure = {
    enable = mkOption {
      type = bool;
      description = "Whether to install Clojure plugins";
      default = false;
    };

    kondo.enable = mkOption
      {
        type = bool;
        description = "Add ALE to use clj-kondo";
        default = false;
      };
  };

  options.programs.neovim.haskell = {
    hlint.enable = mkOption
      {
        type = bool;
        description = "Add ALE to use hlint";
        default = false;
      };
  };

  options.programs.neovim.lsp = {
    enable = mkOption {
      type = bool;
      description = "Enable LSP functionality";
      default = true;
    };

    backend = mkOption {
      type = enum [ "nvim-lsp" ];
      description = "Which LSP backend to use";
      default = "nvim-lsp";
    };
  };

  options.programs.neovim.ale = {
    enable = mkOption {
      type = bool;
      description = ''
        Use ALE for diagnostics
      '';
      default = true;
    };
  };

  options.programs.neovim.completion = {
    enable = mkOption {
      type = bool;
      description = "Whether to use a special plugin for completion, such as 'mucomplete' or 'completion-nvim'";
      default = false;
    };

    backend = mkOption {
      type = enum [ "completion-nvim" "deoplete" ];
      description = "Which completion plugin(s) to use";
      default = "deoplete";
    };

    preview.enable = mkOption {
      type = bool;
      description = ''
        Neovim has a preview option for completion which can be a bit
        annoying sometimes. If this is enabled then "preview" is added
        to completeopt.
      '';
      default = true;
    };

    float-preview-nvim.enable = mkOption {
      type = bool;
      description = ''
        Use this plugin https://github.com/ncm2/float-preview.nvim for
        floating previews. I don't really know if or how this applies without
        Deoplete, but /shrug
      '';
      default = false;
    };
  };

  options.programs.neovim.telescope = {

    enable = mkOption {
      type = bool;
      description = "Whether to enable the telescope plugin (and dependencies)";
      default = false;
    };

    prefix = mkOption {
      type = str;
      description = "Prefix to use for all telescope mappings";
      default = "<leader>t";
    };

  };

  options.programs.neovim.git = {

    committia = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

    gv = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

    signify = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

    messenger = {
      enable = mkOption {
        type = bool;
        default = false;
      };
    };

  };

  options.programs.neovim.editor = {
    asterisk = mkOption {
      type = bool;
      description = "Better * handling";
      default = false;
    };

    sneak = mkOption {
      type = bool;
      description = "Better buffer navigation";
      default = false;
    };

    sad = mkOption {
      type = bool;
      description = "Easily operate on surroundings like ( { [";
      default = false;
    };

    colorizer = mkOption {
      type = bool;
      description = "Show colors through background colors";
      default = false;
    };

    highlight-current-word = mkOption {
      type = bool;
      description = "Install a plugin ('vim-illuminate') which highlights the word under the cursor";
      default = false;
    };
  };

  options.programs.neovim.treesitter = {

    enable = mkOption {
      type = bool;
      description = "Whether to enable treesitter grammars for Neovim (will install 'nvim-treesitter')";
      default = false;
    };

    clojure = mkOption {
      type = grammarConfigModule;
      description = "Clojure treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    nix = mkOption {
      type = grammarConfigModule;
      description = "Nix treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    go = mkOption {
      type = grammarConfigModule;
      description = "Go treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    ts = mkOption {
      type = grammarConfigModule;
      description = "Typescript treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    tsx = mkOption {
      type = grammarConfigModule;
      description = "Typescript TSX treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

    yaml = mkOption {
      type = grammarConfigModule;
      description = "Yaml treesitter grammar";
      example = literalExample ''
        {
          rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        };
      '';
    };

  };
}
