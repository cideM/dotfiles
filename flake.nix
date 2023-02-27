{
  description = "今日は";

  inputs = rec {
    zig-overlay.url = "github:mitchellh/zig-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    /*
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    */
    flake-utils.url = "github:numtide/flake-utils";

    parinfer-rust.url = "github:eraserhd/parinfer-rust";
    parinfer-rust.flake = false;

    lucid-fish-prompt-src.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt-src.flake = false;

    nix-env-fish-src.url = "github:lilyball/nix-env.fish";
    nix-env-fish-src.flake = false;

    rose-pine-alacritty-src.url = "github:rose-pine/alacritty";
    rose-pine-alacritty-src.flake = false;

    rosepine.url = "github:rose-pine/neovim";
    rosepine.flake = false;

    rose-pine-fish-src.url = "github:rose-pine/fish";
    rose-pine-fish-src.flake = false;

    spacevimtheme.url = "github:liuchengxu/space-vim-theme";
    spacevimtheme.flake = false;

    vim-js.url = "github:yuezk/vim-js";
    vim-js.flake = false;

    lspfuzzy.url = "github:ojroques/nvim-lspfuzzy";
    lspfuzzy.flake = false;

    yui.url = "github:cidem/yui";
    yui.flake = false;

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "unstable";

    operatorMono = {
      url = "git+ssh://git@github.com/cidem/operatormono?ref=main";
      flake = false;
    };
  };

  outputs = {
    self,
    unstable,
    home-manager,
    flake-utils,
    operatorMono,
    rose-pine-fish-src,
    rose-pine-alacritty-src,
    nixpkgs,
    lspfuzzy,
    nix-env-fish-src,
    lucid-fish-prompt-src,
    zig-overlay,
    yui,
    spacevimtheme,
    vim-js,
    rosepine,
    parinfer-rust,
  }: let
    overlays = [
      (final: prev: rec {zigpkgs = zig-overlay.packages.${prev.system};})

      (self: super: {
        parinfer-rust = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "parinfer-rust";
          src = parinfer-rust;
        };
      })

      (self: super: {
        yui = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "yui";
          src = yui;
        };
      })

      (self: super: {
        rosepine = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "rosepine";
          src = rosepine;
        };
      })

      (self: super: {
        lspfuzzy = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "lspfuzzy";
          src = lspfuzzy;
        };
      })

      (self: super: {
        spacevim = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "spacevim";
          src = spacevimtheme;
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
        vim-js = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "vim-js";
          src = vim-js;
        };
      })

      (self: super: {
        rose-pine-fish = super.pkgs.stdenv.mkDerivation {
          pname = "rose-pine-fish";
          version = "latest";
          src = rose-pine-fish-src;
          buildPhases = ["installPhase"];
          installPhase = ''
            mkdir $out
            cp -R $src/themes $out/themes
          '';
        };
      })

      (self: super: {
        rose-pine-alacritty = super.stdenv.mkDerivation {
          pname = "rose-pine-alacritty";
          version = "latest";
          src = rose-pine-alacritty-src;
          dontUnpack = true;
          dontBuild = true;
          installPhase = ''
            mkdir $out
            cat $src/dist/rose-pine-dawn.yml | ${super.yj}/bin/yj > $out/rose-pine-dawn.json
          '';
        };
      })

      (self: super: {
        lucid-fish-prompt = super.fishPlugins.buildFishPlugin rec {
          pname = "lucid-fish-prompt";
          version = "latest";
          src = lucid-fish-prompt-src;
        };
      })

      (self: super: {
        nix-env-fish = super.fishPlugins.buildFishPlugin rec {
          pname = "nix-env-fish";
          version = "latest";
          src = nix-env-fish-src;
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
      # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
      nixosConfigurations.nixos = desktop;
      inherit homeConfigurations;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [alejandra nodePackages.prettier];
        };
      }
    );
}
