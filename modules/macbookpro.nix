{
  inputs,
  config,
  withSystem,
  ...
}:
let
  userName = "fbs";
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeConfigurations.mbp = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        {
          imports = [
            config.flake.modules.homeManager.nvim
            config.flake.modules.homeManager.fish
            config.flake.modules.homeManager.ghostty
            config.flake.modules.homeManager.common
            config.flake.modules.homeManager.git
          ];

          home = {
            homeDirectory = "/Users/${userName}";
            username = userName;
            stateVersion = "20.09";
            packages =
              let
                gsed = pkgs.runCommand "gsed" { } ''
                  mkdir -p $out/bin
                  ln -s ${pkgs.gnused}/bin/sed $out/bin/gsed
                '';
              in
              pkgs.lib.optionals pkgs.stdenv.isDarwin [ gsed ];
          };

          nix = {
            package = pkgs.nixVersions.latest;
            gc = {
              automatic = true;
              dates = "daily";
            };
          };
        }
      ];
    }
  );
}
