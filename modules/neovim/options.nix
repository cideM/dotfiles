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

    ale_integration = mkOption {
      type = bool;
      description = "Send errors to ALE instead of loclist";
      default = true;
    };
  };

  options.programs.neovim.completion = {
    enable = mkOption {
      type = bool;
      description = "Whether to use a special plugin for completion, such as 'mucomplete' or 'completion-nvim'";
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
