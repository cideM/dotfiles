{ pkgs, ... }:

with pkgs;
with lib;

{
  options.common = {
    flake_registries = mkOption {
      type = types.attrs;
      default = false;
      description = ''
        Flake registry aliases
      '';
    };
  };

  config = {
    common.flake_registries = {
      fbrs = {
        from = {
          id = "fbrs";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "cidem";
          repo = "nix-templates";
        };
      };
    };
  };
}
