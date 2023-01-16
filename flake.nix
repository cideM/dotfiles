{
  description = "今日は";

  inputs = rec {
    helix.url = "github:helix-editor/helix";

    zig-overlay.url = "github:mitchellh/zig-overlay";

    volta-src.url = "github:volta-cli/volta";
    volta-src.flake = false;

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    /* neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay"; */

    arctic-lush.url = "github:rockyzhang24/arctic.nvim";
    arctic-lush.flake = false;

    jellybeans-lush.url = "github:metalelf0/jellybeans-nvim";
    jellybeans-lush.flake = false;

    onedarkpro-lush.url = "github:olimorris/onedarkpro.nvim";
    onedarkpro-lush.flake = false;

    nvim-leap.url = "github:ggandor/leap.nvim";
    nvim-leap.flake = false;

    parinfer-rust.url = "github:eraserhd/parinfer-rust";
    parinfer-rust.flake = false;

    winshift.url = "github:sindrets/winshift.nvim";
    winshift.flake = false;

    lucid-fish-prompt.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt.flake = false;

    nix-env-fish.url = "github:lilyball/nix-env.fish";
    nix-env-fish.flake = false;

    rosepine.url = "github:rose-pine/neovim";
    rosepine.flake = false;

    spacevimtheme.url = "github:liuchengxu/space-vim-theme";
    spacevimtheme.flake = false;

    githubtheme.url = "github:projekt0n/github-nvim-theme";
    githubtheme.flake = false;

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
    operatorMono,
    nixpkgs,
    lspfuzzy,
    winshift,
    nix-env-fish,
    lucid-fish-prompt,
    /* neovim-nightly-overlay, */
    volta-src,
    zig-overlay,
    yui,
    spacevimtheme,
    vim-js,
    rosepine,
    parinfer-rust,
    nvim-leap,
    githubtheme,
    helix,
    arctic-lush,
    jellybeans-lush,
    onedarkpro-lush,
  }: let
    overlays = [
      (self: super: {
        onedarkpro-lush-theme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "onedarkpro-theme";
          src = onedarkpro-lush;
        };
      })

      (self: super: {
        jellybeans-lush-theme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "jellybeans-theme";
          src = jellybeans-lush;
        };
      })

      (self: super: {
        arctic-lush-theme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "arctic-lush-theme";
          src = arctic-lush;
        };
      })

      (final: prev: rec {zigpkgs = zig-overlay.packages.${prev.system};})

      (self: super: let
        shas = {
          "aarch64-darwin" = "sha256-P/jW95Udtw9ZjlS/ipaOTCup56fAZAXktHsUbJV+GxY=";
          "x86_64-linux" = "sha256-6DHzMeNREoJT4fsRKDmB/VcfEUkAWAx0CnL5YDVNIt4=";
        };
      in {
        volta = super.rustPlatform.buildRustPackage rec {
          pname = "volta";
          version = "1.1.0";
          src = volta-src;
          cargoSha256 = shas."${super.system}";
          buildInputs = super.lib.optionals super.stdenv.isDarwin [super.darwin.apple_sdk.frameworks.Security super.libiconv];

          meta = with super.lib; {
            description = "The Hassle-Free JavaScript Tool Manager";
            longDescription = ''
              Volta’s job is to get out of your way.

              With Volta, you can select a Node engine once and then stop worrying about it. You can switch between projects and stop having to manually switch between Nodes. You can install npm package binaries in your toolchain without having to periodically reinstall them or figure out why they’ve stopped working.
            '';
            homepage = "https://docs.volta.sh";
            license = with licenses; [bsd2];
            # maintainers = with maintainers; [ fbrs ];
          };
        };
      })

      (self: super: {
        nvim-leap = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "nvim-leap";
          src = nvim-leap;
        };
      })

      (self: super: {
        parinfer-rust = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "parinfer-rust";
          src = parinfer-rust;
        };
      })

      (self: super: {
        winshift = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "winshift";
          src = winshift;
        };
      })

      (self: super: {
        helix = helix.packages.${super.system}.helix;
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
        githubtheme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          version = "latest";
          pname = "githubtheme";
          src = githubtheme;
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
    ];

    specialArgs = {
      inherit home-manager nix-env-fish lucid-fish-prompt;
    };

    homeConfigurations = {
      work-m1 = home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = specialArgs;
        pkgs = import unstable {
          system = "aarch64-darwin";
        };
        modules = [
          ./modules/regs.nix
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
        ./modules/regs.nix
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
  in {
    # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
    nixosConfigurations.nixos = desktop;
    inherit homeConfigurations;
  };
}
