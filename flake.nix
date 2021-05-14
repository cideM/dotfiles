{
  description = "Nix. All. The. Things.";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    lucid-fish.url = "github:mattgreen/lucid.fish";
    lucid-fish.flake = false;

    lspfuzzy.url = "github:ojroques/nvim-lspfuzzy";
    lspfuzzy.flake = false;

    sad.url = "github:hauleth/sad.vim";
    sad.flake = false;

    yui.url = "github:cidem/yui";
    yui.flake = false;

    qfenter.url = "github:yssl/QFEnter";
    qfenter.flake = false;

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hwConfig = {
      url = "/etc/nixos/hardware-configuration.nix";
      flake = false;
    };

    scripts = {
      url = "git+ssh://git@github.com/cidem/scripts?ref=main";
      flake = false;
    };

    operatorMono = {
      url = "/home/tifa/OperatorMono";
      flake = false;
    };

  };

  outputs =
    { self
    , neovim-nightly-overlay
    , unstable
    , home-manager
    , operatorMono
    , hwConfig
    , nixpkgs
    , scripts
    , lspfuzzy
    , sad
    , yui
    , lucid-fish
    , qfenter
    }:
    {
      # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
      nixosConfigurations.nixos =
        let
          system = "x86_64-linux";

          specialArgs = {
            inherit hwConfig operatorMono neovim-nightly-overlay scripts lspfuzzy sad yui qfenter lucid-fish;
          };

          modules = [
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
              nixpkgs.config = {
                allowUnfree = true;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tifa = import ./hosts/nixos/home.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        in
        unstable.lib.nixosSystem { inherit system modules specialArgs; };

    };
}
