{ config, lib, pkgs, ... }:

# TODO: Should just add all automatically
builtins.map
  (pkg: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = pkg;
    version = "latest";
    src = ./. + "/plugins" + ("/" + pkg);
  })
  [
    "find-utils"
    "path-utils"
    "reflow"
    "syntax"
    "zen"
    "goutils"
  ]
