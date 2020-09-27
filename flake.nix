{
  description = "Nix. All. The. Things.";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      # https://github.com/nix-community/home-manager/blob/master/flake.nix#L4
      # HM takes 'nixpkgs' as input
      inputs.nixpkgs.follows = "/unstable";
    };

    operatorMono = {
      url = "/home/tifa/OperatorMono";
      flake = false;
    };

    unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
  };

  outputs = { self, unstable, home-manager, operatorMono }:
    let
      pkgs = import unstable {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      };

    in
    {
      nixosConfigurations.nixos =
        let
          system = "x86_64-linux";

          specialArgs = {
            inherit pkgs operatorMono;
          };

          hm-nixos-as-super = { config, ... }: {
            # Submodules have merge semantics, making it possible to amend
            # the `home-manager.users` submodule for additional functionality.
            options.home-manager.users = unstable.lib.mkOption {
              type = unstable.lib.types.attrsOf (unstable.lib.types.submoduleWith {
                modules = [ ];
                # Makes specialArgs available to Home Manager modules as well.
                specialArgs = specialArgs // {
                  # Allow accessing the parent NixOS configuration.
                  super = config;
                };
              });
            };
          };

          modules = [
            home-manager.nixosModules.home-manager
            hm-nixos-as-super
            ./nix/hosts/nixos/configuration.nix
          ];
        in
        unstable.lib.nixosSystem { inherit system modules specialArgs; };

    };
}
