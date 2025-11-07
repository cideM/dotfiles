# This is a required import, since each *.nix file in this folder is a flake
# parts module. Not a NixOS or Home Manager module.
# Without the import, nothing will work.
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
