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

    indent-blankline.url = "github:lukas-reineke/indent-blankline.nvim/lua";
    indent-blankline.flake = false;

    sad.url = "github:hauleth/sad.vim";
    sad.flake = false;

    yui.url = "github:cidem/yui";
    yui.flake = false;

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
    , indent-blankline
    , lspfuzzy
    , sad
    , yui
    , lucid-fish
    }:
    {
      # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
      nixosConfigurations.nixos =
        let
          system = "x86_64-linux";

          overlays = [
            neovim-nightly-overlay.overlay
            (self: super: {
              kubectl = super.kubectl.overrideAttrs (old: rec {
                name = "kubectl-${version}";

                version = "1.15";
                src = builtins.fetchurl {
                  url = "https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.11/2020-08-04/bin/linux/amd64/kubectl";
                  sha256 = "1knchnf6bh68lx12zpz2jjjd81zgm02jrcbxpzs71dniwasdghqc";
                };
              });
            })
          ];

          specialArgs = {
            inherit hwConfig operatorMono neovim-nightly-overlay scripts lspfuzzy sad yui lucid-fish indent-blankline;
          };

          modules = [
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
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
