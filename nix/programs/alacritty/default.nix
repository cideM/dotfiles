let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  # The Dhall offline caching I use here is explained in
  # - https://discourse.dhall-lang.org/t/help-with-builddhallpackage/297/2
  # - https://github.com/Gabriel439/nixpkgs/blob/9f2dd99705546b075f1d95b50331c613ca36e300/pkgs/development/interpreters/dhall/build-dhall-package.nix
  # - https://discourse.dhall-lang.org/t/offline-use-of-prelude/137

  prelude = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-lang-prelude";
    code = "${sources.dhall-lang}/Prelude/package.dhall";
  };

  # TODO: Fix in source so I can just cache prelude above
  preludeMap = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-lang-prelude";
    code = "${sources.dhall-lang}/Prelude/Map/Type";
  };

  #################################
  # Cache dhall-alacritty imports #
  #################################

  alacrittyColors = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-alacritty";
    code = "${sources.dhall-alacritty}/colors.dhall";
  };

  alacrittyKeys = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-alacritty";
    code = "${sources.dhall-alacritty}/keys/common.dhall";
    dependencies = [
      prelude
    ];
  };

  alacrittyLinuxBase = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-alacritty";
    code = "${sources.dhall-alacritty}/linux.dhall";
    dependencies = [
      prelude
      preludeMap
    ];
  };

  alacrittyDarwinBase = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-alacritty";
    code = "${sources.dhall-alacritty}/macos.dhall";
    dependencies = [
      prelude
      preludeMap
    ];
  };

  ##################################
  # Evaluate the config expression #
  ##################################
  linuxConfig = pkgs.dhallPackages.buildDhallPackage {
    name = "alacritty_linux";
    code = "${./src}/linux.dhall";
    # Important so I can pass this source file to dhall-to-json
    source = true;
    dependencies = [
      alacrittyLinuxBase
      alacrittyColors
      alacrittyKeys
    ];
  };

  # TODO: Remove the duplication here
  darwinConfig = pkgs.dhallPackages.buildDhallPackage {
    name = "alacritty_darwin";
    code = "${./src}/macos.dhall";
    # Important so I can pass this source file to dhall-to-json
    source = true;
    dependencies = [
      alacrittyDarwinBase
      alacrittyColors
      alacrittyKeys
    ];
  };

  nixosConfig = pkgs.dhallPackages.buildDhallPackage {
    name = "alacritty_nixos";
    code = "${./src}/nixos.dhall";
    # Important so I can pass this source file to dhall-to-json
    source = true;
    dependencies = [
      alacrittyLinuxBase
      alacrittyColors
      alacrittyKeys
    ];
  };


  linux = derivation {
    name = "alacritty_linux.yml";
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./builder.sh ];
    dhalljson = pkgs.haskellPackages.dhall-json;
    config = linuxConfig;
    src = ./src;
    system = builtins.currentSystem;
  };

  macos = derivation {
    name = "alacritty_darwin.yml";
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./builder.sh ];
    dhalljson = pkgs.haskellPackages.dhall-json;
    config = darwinConfig;
    src = ./src;
    system = builtins.currentSystem;
  };

  nixos = derivation {
    name = "alacritty_nixos.yml";
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./builder.sh ];
    dhalljson = pkgs.haskellPackages.dhall-json;
    config = nixosConfig;
    src = ./src;
    system = builtins.currentSystem;
  };


in
{ inherit linux macos nixos; }
