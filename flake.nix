{
  description = "Nix. All. The. Things.";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "/unstable";
    };

    operatorMono = {
      url = "/home/tifa/OperatorMono";
      flake = false;
    };

    # nixpkgs = {
    #   url = "github:NixOS/nixpkgs/nixos-20.03";
    # };

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

          # https://github.com/nix-community/home-manager
          # I have no idea what this snippet does, I just copied it from the
          # flake docs. It creates a new module, which adds a new option, or
          # in this case a submodule (?). It inherits specialArgs and... sets
          # super to the super config? Hmm... *head scratching*
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
