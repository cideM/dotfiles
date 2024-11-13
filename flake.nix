{
  description = "今日は";

  inputs = rec {
    zig-overlay.url = "github:mitchellh/zig-overlay";

    hledger-src.url = "github:simonmichael/hledger";
    hledger-src.flake = false;

    github-markdown-toc-go-src = {
      url = "github:ekalinin/github-markdown-toc.go";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    github-nvim-theme-src.url = "github:projekt0n/github-nvim-theme";
    github-nvim-theme-src.flake = false;

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nix-fish-src.url = "github:kidonng/nix.fish";
    nix-fish-src.flake = false;

    janet-vim.url = "github:janet-lang/janet.vim";
    janet-vim.flake = false;

    lucid-fish-prompt-src.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt-src.flake = false;

    vim-js.url = "github:yuezk/vim-js";
    vim-js.flake = false;

    lspfuzzy.url = "github:ojroques/nvim-lspfuzzy";
    lspfuzzy.flake = false;

    # yui.url = "path:/Users/fbs/private/yui";
    yui.url = "github:cidem/yui";
    yui.flake = true;

    nixMaster = {
      url = "github:NixOS/nixpkgs/master";
    };

    # unstable-local.url = "path:/Users/fbs/private/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";

    operatorMono = {
      url = "git+ssh://git@github.com/cidem/operatormono?ref=main";
      flake = false;
    };
  };

  outputs = {
    self,
    janet-vim,
    unstable,
    github-nvim-theme-src,
    # unstable-local,
    nixMaster,
    home-manager,
    flake-utils,
    hledger-src,
    neovim-nightly-overlay,
    operatorMono,
    lix-module,
    github-markdown-toc-go-src,
    nixpkgs,
    lspfuzzy,
    nix-fish-src,
    lucid-fish-prompt-src,
    zig-overlay,
    yui,
    vim-js,
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default

      (final: prev: rec {zigpkgs = zig-overlay.packages.${prev.system};})

      (final: prev: {
        master-packages = import nixMaster {
          system = final.system;
          config.allowUnfree = true;
        };
      })

      (self: super: {
        github-markdown-toc = super.buildGoModule {
          name = "github-markdown-toc-go";
          version = "latest";
          src = github-markdown-toc-go-src;
          vendorHash = "sha256-K5yb7bnW6eS5UESK9wgNEUwGjB63eJk6+B0jFFiFero=";
        };
      })

      (self: super: {
        yui-alacritty-theme = yui.packages.${super.system}.alacritty;
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            yui = yui.packages.${super.system}.neovim;
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            github-nvim-theme = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "github-nvim-theme";
              src = github-nvim-theme-src;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            lspfuzzy = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "lspfuzzy";
              src = lspfuzzy;
            };
          };
      })

      (self: super: {
        operatorMonoFont = super.pkgs.stdenv.mkDerivation {
          name = "operator-mono-font";
          src = operatorMono;
          buildPhases = ["installPhase"];
          installPhase = ''
            mkdir -p $out/share/fonts/operator-mono
            cp -R "$src" "$out/share/fonts/operator-mono"
          '';
        };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            janet-vim = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "janet-vim";
              src = janet-vim;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            vim-js = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "vim-js";
              src = vim-js;
            };
          };
      })

      (final: prev: {
        fishPlugins = prev.fishPlugins.overrideScope (finalx: prevx: {
          yui = yui.packages.${final.system}.fish_light;
        });
      })

      (self: super: {
        oil = super.oil.overrideAttrs (old: {
          env.NIX_CFLAGS_COMPILE = super.lib.optionalString super.stdenv.cc.isClang "-Wno-error=incompatible-function-pointer-types";
        });
      })

      (self: super: {
        lucid-fish-prompt = super.pkgs.stdenv.mkDerivation {
          pname = "lucid-fish-prompt";
          version = "latest";
          src = lucid-fish-prompt-src;
        };
      })

      (self: super: {
        nix-fish = super.pkgs.stdenv.mkDerivation rec {
          pname = "nix-fish";
          version = "latest";
          src = nix-fish-src;
        };
      })
    ];

    specialArgs = {
      inherit home-manager;
    };

    homeConfigurations = {
      work-m1 = home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = specialArgs;
        pkgs = import unstable {
          system = "aarch64-darwin";
        };
        modules = [
          {
            home = {
              homeDirectory = "/Users/fbs";
              username = "fbs";
            };
          }
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = {
              allowUnfree = true;
            };
          }
          ./hosts/fbs-work.local/home.nix
          # lix-module.nixosModules.default
        ];
      };
    };

    desktop = let
      system = "x86_64-linux";

      modules = [
        ./hosts/nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config = {
            allowUnfree = true;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = false;
          home-manager.verbose = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.fbrs = import ./hosts/nixos/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    in
      unstable.lib.nixosSystem {inherit system modules specialArgs;};
  in
    {
      nixosConfigurations.nixos = desktop;
      inherit homeConfigurations;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [alejandra nodePackages.prettier stylua];
        };
      }
    );
}
