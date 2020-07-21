{ pkgs, sources, ...}:

let
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
    name = "dhall-alacritty-colors";
    code = "${sources.dhall-alacritty}/colors.dhall";
  };

  alacrittyKeys = pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-alacritty-keys";
    code = "${sources.dhall-alacritty}/keys/common.dhall";
    dependencies = [
      prelude
    ];
  };

  base = filename: pkgs.dhallPackages.buildDhallPackage {
    name = "dhall-alacritty-base";
    code = "${sources.dhall-alacritty}/${filename}.dhall";
    dependencies = [
      prelude
      preludeMap
    ];
  };

  alacrittyLinuxBase = base "linux";

  alacrittyDarwinBase = base "macos";

  ##################################
  # Evaluate the config expression #
  ##################################
  makeConfig = os: baseDependency: pkgs.dhallPackages.buildDhallPackage {
    name = "alacritty_${os}";
    code = "${./src}/${os}.dhall";
    # Important so I can pass this source file to dhall-to-json
    source = true;
    dependencies = [
      baseDependency
      alacrittyColors
      alacrittyKeys
    ];
  };

  linuxConfig = makeConfig "linux" alacrittyLinuxBase;

  darwinConfig = makeConfig "macos" alacrittyDarwinBase;

  nixosConfig = makeConfig "nixos" alacrittyLinuxBase;

  makeDerivation = name: config: derivation {
    name = name;
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./builder.sh ];
    dhalljson = pkgs.dhall-json;
    config = config;
    src = ./src;
    system = builtins.currentSystem;
  };

  linux = makeDerivation "alacritty_linux.yml" linuxConfig;

  macos = makeDerivation "alacritty_macos.yml" darwinConfig;

  nixos = makeDerivation "alacritty_nixos.yml" nixosConfig;

in
{ inherit linux macos nixos; }
