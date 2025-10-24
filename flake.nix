{
  description = "今日は";

  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig-overlay.url = "github:mitchellh/zig-overlay";

    github-markdown-toc-go-src = {
      url = "github:ekalinin/github-markdown-toc.go";
      flake = false;
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    flake-utils.url = "github:numtide/flake-utils";

    nix-fish-src.url = "github:kidonng/nix.fish";
    nix-fish-src.flake = false;

    janet-vim.url = "github:janet-lang/janet.vim";
    janet-vim.flake = false;

    nvim-alabaster-scheme-src.url = "github:p00f/alabaster.nvim";
    nvim-alabaster-scheme-src.flake = false;

    vim-js.url = "github:yuezk/vim-js";
    vim-js.flake = false;

    # yui.url = "path:/home/fbrs/private/yui";
    # yui.url = "path:/Users/fbs/private/yui";
    yui.url = "github:cidem/yui";
    yui.flake = true;

    operatorMono = {
      url = "git+ssh://git@github.com/cidem/operatormono?ref=main";
      flake = false;
    };
  };

  outputs =
    {
      self,
      janet-vim,
      home-manager,
      flake-utils,
      neovim-nightly-overlay,
      operatorMono,
      nvim-alabaster-scheme-src,
      github-markdown-toc-go-src,
      nixpkgs,
      nix-fish-src,
      zig-overlay,
      yui,
      vim-js,
    }@inputs:
    let
      overlays = [
        (final: prev: {
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })

        (final: prev: rec { zigpkgs = zig-overlay.packages.${prev.system}; })

        (self: super: {
          github-markdown-toc = super.buildGoModule {
            name = "github-markdown-toc-go";
            version = "latest";
            src = github-markdown-toc-go-src;
            vendorHash = "sha256-K5yb7bnW6eS5UESK9wgNEUwGjB63eJk6+B0jFFiFero=";
          };
        })

        (self: super: {
          yui-ghostty-theme = yui.packages.${super.system}.ghostty;
        })

        (self: super: {
          yui-alacritty-theme = yui.packages.${super.system}.alacritty;
        })

        (self: super: {
          vimPlugins = super.vimPlugins // {
            yui = yui.packages.${super.system}.neovim;
          };
        })

        (self: super: {
          operatorMonoFont = super.pkgs.stdenv.mkDerivation {
            name = "operator-mono-font";
            src = operatorMono;
            buildPhases = [ "installPhase" ];
            installPhase = ''
              mkdir -p $out/share/fonts/operator-mono
              cp -R "$src" "$out/share/fonts/operator-mono"
            '';
          };
        })

        (self: super: {
          vimPlugins = super.vimPlugins // {
            janet-vim = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "janet-vim";
              src = janet-vim;
            };
          };
        })

        (self: super: {
          vimPlugins = super.vimPlugins // {
            nvim-alabaster-theme = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "nvim-alabaster-theme";
              src = nvim-alabaster-scheme-src;
            };
          };
        })

        (self: super: {
          vimPlugins = super.vimPlugins // {
            vim-js = super.pkgs.vimUtils.buildVimPlugin rec {
              version = "latest";
              pname = "vim-js";
              src = vim-js;
            };
          };
        })

        (final: prev: {
          fishPlugins = prev.fishPlugins.overrideScope (
            finalx: prevx: {
              yui = yui.packages.${final.system}.fish_light;
            }
          );
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
        inherit home-manager inputs;
      };

      homeConfigurations = {
        work-m1 = home-manager.lib.homeManagerConfiguration rec {
          extraSpecialArgs = specialArgs;
          pkgs = import nixpkgs {
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
          ];
        };
      };

      vm =
        let
          system = "aarch64-linux";

          modules = [
            ./hosts/vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config = {
                allowUnfree = true;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.verbose = true;
              home-manager.users.fbrs = import ./hosts/vm/home.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        in
        nixpkgs.lib.nixosSystem { inherit system modules specialArgs; };
    in
    {
      nixosConfigurations.vm = vm;
      inherit homeConfigurations;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            janet
            jpm
            nixfmt
            nodePackages.prettier
            lua-language-server
            lua
            stylua
            claude-code
          ];
        };
      }
    );
}
