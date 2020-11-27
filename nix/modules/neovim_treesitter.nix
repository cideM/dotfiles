{ lib, config, pkgs, ... }:

with lib;
with types;
let
  cfg = config.programs.neovim.treesitter;

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
  options.programs.neovim.treesitter = {

    enable = mkOption {
      type = bool;
      description = "Whether to enable treesitter grammars for Neovim (will install 'nvim-treesitter')";
      default = false;
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

    ts = mkOption { };

    tsx = mkOption { };

    yaml = mkOption { };

  };
}
