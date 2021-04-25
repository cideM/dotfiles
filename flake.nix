{
  description = "Nix. All. The. Things.";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hwConfig = {
      url = "/etc/nixos/hardware-configuration.nix";
      flake = false;
    };

    operatorMono = {
      url = "/home/tifa/OperatorMono";
      flake = false;
    };

  };

  outputs = { self, neovim-nightly-overlay, unstable, home-manager, operatorMono, hwConfig, nixpkgs }:
    {
      # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
      nixosConfigurations.nixos =
        let
          system = "x86_64-linux";

          specialArgs = {
            inherit hwConfig operatorMono neovim-nightly-overlay;
          };

          modules = [
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tifa = import ./hosts/nixos/home.nix;
            }
          ];
        in
        unstable.lib.nixosSystem { inherit system modules specialArgs; };

    };
}
