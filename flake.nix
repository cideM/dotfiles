{
  description = "Nix. All. The. Things.";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    everforest.url = "github:sainnhe/everforest";
    everforest.flake = false;

    k9s.url = "github:derailed/k9s";
    k9s.flake = false;

    githubtheme.url = "github:projekt0n/github-nvim-theme";
    githubtheme.flake = false;

    doomonetheme.url = "github:NTBBloodbath/doom-one.nvim";
    doomonetheme.flake = false;

    spacevimtheme.url = "github:liuchengxu/space-vim-theme";
    spacevimtheme.flake = false;

    # Treesitter
    ts-nix.url = "github:cstrahan/tree-sitter-nix/50f38ceab667f9d482640edfee803d74f4edeba5";
    ts-nix.flake = false;

    ts-clj.url = "github:sogaiu/tree-sitter-clojure/f7d100c4fbaa8aad537e80c7974c470c7fb6aeda";
    ts-clj.flake = false;

    ts-yaml.url = "github:ikatyang/tree-sitter-yaml/0e36bed171768908f331ff7dff9d956bae016efb";
    ts-yaml.flake = false;

    ts-js.url = "github:tree-sitter/tree-sitter-javascript/45b9ce2a2588c0e6d616b0ee2a710b1fcb99c5b5";
    ts-js.flake = false;

    ts-rust.url = "github:tree-sitter/tree-sitter-rust/a360da0a29a19c281d08295a35ecd0544d2da211";
    ts-rust.flake = false;

    ts-lua.url = "github:nvim-treesitter/tree-sitter-lua/b6d4e9e10ccb7b3afb45018fbc391b4439306b23";
    ts-lua.flake = false;

    ts-ts.url = "github:tree-sitter/tree-sitter-typescript/28e757a2f498486931b3cb13a100a1bcc9261456";
    ts-ts.flake = false;

    ts-python.url = "github:tree-sitter/tree-sitter-python/d6210ceab11e8d812d4ab59c07c81458ec6e5184";
    ts-python.flake = false;

    ts-haskell.url = "github:tree-sitter/tree-sitter-haskell/a0c1adb59e390f7d839a146c57fdb33d36ed97e6";
    ts-haskell.flake = false;

    ts-go.url = "github:tree-sitter/tree-sitter-go/eb306e6e60f393df346cfc8cbfaf52667a37128a";
    ts-go.flake = false;

    lucid-fish.url = "github:mattgreen/lucid.fish";
    lucid-fish.flake = false;

    lightspeed.url = "github:ggandor/lightspeed.nvim";
    lightspeed.flake = false;

    lspfuzzy.url = "github:ojroques/nvim-lspfuzzy";
    lspfuzzy.flake = false;

    material.url = "github:marko-cerovac/material.nvim";
    material.flake = false;

    indent-blankline.url = "github:lukas-reineke/indent-blankline.nvim/lua";
    indent-blankline.flake = false;

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
    , operatorMono
    , nixpkgs
    , scripts
    , indent-blankline
    , lspfuzzy
    , k9s
    , material
    , yui
    , lucid-fish
    , ts-nix
    , ts-clj
    , ts-go
    , ts-lua
    , ts-ts
    , ts-js
    , ts-rust
    , spacevimtheme
    , doomonetheme
    , githubtheme
    , ts-yaml
    , ts-haskell
    , ts-python
    , everforest
    , lightspeed
    }:
    let
      overlays = [
        (self: super: {
          vscode = super.vscode.overrideAttrs (old: {
            preInstall =
              if (super.pkgs.stdenv.hostPlatform.system == "x86_64-darwin" || super.pkgs.stdenv.hostPlatform.system == "aarch64-darwin") then ""
              else ''
                cp ./bin/code-insiders ./bin/code
              '';
          });
        })

        (self: super: {
          ledger-live-desktop = super.ledger-live-desktop.overrideAttrs (old: rec {
            pname = "ledger-live-desktop";
            version = "2.29.0";
            src = builtins.fetchurl {
              url = "https://github.com/LedgerHQ/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
              sha256 = "1y4xvnwh2mqbc39pmnpgjg8mlx208s2pipm7dazq4bgmay7k9zh0";
            };
          });
        })

        neovim-nightly-overlay.overlay

        (self: super: {
          nix-direnv = super.nix-direnv.overrideAttrs (old: rec {
            version = "ccc2e4c5db2869184a7181109cee0d42cd62120f";
            src = super.fetchFromGitHub {
              owner = "nix-community";
              repo = "nix-direnv";
              rev = version;
              sha256 = "1kc0x9m53gvkcg2x0sg8ydw1r3k7ppisrr0bsvlvbrff81jr4kwn";
            };
          });
        })

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
        inherit operatorMono
          neovim-nightly-overlay
          scripts
          lspfuzzy
          material
          home-manager
          yui
          spacevimtheme
          lucid-fish
          ts-nix
          ts-clj
          ts-go
          ts-lua
          ts-ts
          ts-js
          ts-rust
          doomonetheme
          githubtheme
          ts-yaml
          ts-haskell
          ts-python
          everforest
          lightspeed
          k9s
          indent-blankline;
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
                  nixpkgs.overlays = overlays ++ [ ];
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
                  nixpkgs.overlays = overlays ++ [ ];
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
              nixpkgs.overlays = overlays ++ [ ];
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
      inherit homeConfigurations;
    };
}
