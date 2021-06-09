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

    direnv.url = "github:nix-community/nix-direnv";

    material.url = "github:marko-cerovac/material.nvim";
    material.flake = false;

    indent-blankline.url = "github:lukas-reineke/indent-blankline.nvim/lua";
    indent-blankline.flake = false;

    sad.url = "github:hauleth/sad.vim";
    sad.flake = false;

    yui.url = "github:cidem/yui";
    yui.flake = false;

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    scripts = {
      url = "git+ssh://git@github.com/cidem/scripts?ref=main";
      flake = false;
    };

    operatorMono = {
      url = "git+ssh://git@github.com/cidem/operatormono?ref=main";
      flake = false;
    };

  };

  outputs =
    { self
    , neovim-nightly-overlay
    , unstable
    , home-manager
    , direnv
    , operatorMono
    , nixpkgs
    , scripts
    , indent-blankline
    , lspfuzzy
    , material
    , sad
    , yui
    , lucid-fish
    }:
    let
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
        inherit operatorMono neovim-nightly-overlay scripts lspfuzzy material sad yui lucid-fish indent-blankline;
      };

      homeConfigurations = {
        work-mbp = home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-darwin";
          extraSpecialArgs = specialArgs;
          pkgs = import unstable {
            inherit system;
          };
          homeDirectory = "/Users/fbs";
          username = "fbs";
          configuration = { pkgs, config, ... }:
            {
              imports = [
                {
                  nixpkgs.overlays = overlays ++ [
                    # TL;DR: Can't have flake.nix not in Git but if you don't
                    # want to impose Nix on colleagues you can put flake.nix in
                    # other folder where it is tracked by Git and then you need
                    # a very recent nix-direnv PR which will let you do use
                    # flake ~/foo#bar and so that's why I'm overriding it here.
                    (self: super: { nix-direnv = direnv.defaultPackage.${system}; })
                  ];
                  nixpkgs.config = {
                    allowUnfree = true;
                  };
                }
                ./hosts/fbs-work.local/home.nix
              ];
            };
        };
      };

      desktop =
        let
          system = "x86_64-linux";

          modules = [
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays ++ [
                (self: super: { nix-direnv = direnv.defaultPackage.${system}; })
              ];
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
    in
    {
      # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
      nixosConfigurations.nixos = desktop;
      mbp = homeConfigurations.work-mbp.activationPackage;
    };
}
