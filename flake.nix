{
  description = "今日は";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    cidem-vsc.url = "github:cideM/visual-studio-code-insiders-nix";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "unstable";
    };

    parinfer-rust.url = "github:eraserhd/parinfer-rust";
    parinfer-rust.flake = false;

    kubectl-nix.url = "github:cidem/kubectl-nix";

    everforest.url = "github:sainnhe/everforest";
    everforest.flake = false;

    winshift.url = "github:sindrets/winshift.nvim";
    winshift.flake = false;

    lucid-fish-prompt.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt.flake = false;

    nix-env-fish.url = "github:lilyball/nix-env.fish";
    nix-env-fish.flake = false;

    visual-split-nvim.url = "github:wellle/visual-split.vim";
    visual-split-nvim.flake = false;

    vim-lua.url = "github:tbastos/vim-lua";
    vim-lua.flake = false;

    k9s.url = "github:derailed/k9s";
    k9s.flake = false;

    doomonetheme.url = "github:NTBBloodbath/doom-one.nvim";
    doomonetheme.flake = false;

    spacevimtheme.url = "github:liuchengxu/space-vim-theme";
    spacevimtheme.flake = false;

    vim-js.url = "github:yuezk/vim-js";
    vim-js.flake = false;

    lightspeed.url = "github:ggandor/lightspeed.nvim";
    lightspeed.flake = false;

    lspfuzzy.url = "github:ojroques/nvim-lspfuzzy";
    lspfuzzy.flake = false;

    yui.url = "github:cidem/yui";
    yui.flake = false;

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";

    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-flake.inputs.nixpkgs.follows = "unstable";

    operatorMono = {
      url = "git+ssh://git@github.com/cidem/operatormono?ref=main";
      flake = false;
    };

  };

  outputs =
    { self
    , neovim-flake
    , unstable
    , home-manager
    , operatorMono
    , nixpkgs
    , lspfuzzy
    , winshift
    , k9s
    , visual-split-nvim
    , nix-env-fish
    , lucid-fish-prompt
    , vim-lua
    , cidem-vsc
    , yui
    , spacevimtheme
    , vim-js
    , doomonetheme
    , everforest
    , lightspeed
    , parinfer-rust
    , kubectl-nix
    , fenix
    }:
    let
      overlays = [
        fenix.overlay

        (self: super: {
          kubectl = kubectl-nix.packages.${if super.system == "aarch64-darwin" then "x86_64-darwin" else super.system}."1_19_3";
        })

        (self: super: {
          vscodeInsiders = cidem-vsc.packages.${super.system}.vscodeInsiders;
        })

        (self: super: {
          parinfer-rust = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "parinfer-rust"; src = parinfer-rust; };
        })

        (self: super: {
          winshift = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "winshift"; src = winshift; };
        })

        (self: super: {
          vim-lua = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "vim-lua"; src = vim-lua; };
        })

        (self: super: {
          vim-js = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "vim-js"; src = vim-js; };
        })

        (self: super: {
          visual-split-nvim = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "visual-split"; src = visual-split-nvim; };
        })
      ];

      pkgsCompat = import unstable {
        system = "x86_64-darwin";
      };

      specialArgs = {
        inherit operatorMono
          lspfuzzy
          home-manager
          yui
          spacevimtheme
          nix-env-fish
          lucid-fish-prompt
          doomonetheme
          everforest
          lightspeed
          k9s;
      };

      homeConfigurations = {
        work-m1 = home-manager.lib.homeManagerConfiguration rec {
          system = "aarch64-darwin";
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


                    (self: super: rec {
                      kitty = pkgsCompat.kitty;
                    })

                  ];
                  nixpkgs.config = {
                    allowUnfree = true;

                  };
                }
                ./hosts/fbs-work.local/home.nix
              ];
            };
        };

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
                    (self: super: rec {
                      neovim = neovim-flake.packages."x86_64-darwin".neovim;
                    })
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
                (self: super: rec {
                  neovim = neovim-flake.packages."x86_64-linux".neovim;
                })
              ];
              nixpkgs.config = {
                allowUnfree = true;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.verbose = true;
              home-manager.backupFileExtension = "hm-backup";
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
      inherit homeConfigurations;
    };
}
