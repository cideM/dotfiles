{
  description = "今日は";

  inputs = rec {
    zig-overlay.url = "github:mitchellh/zig-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nix-fish-src.url = "github:kidonng/nix.fish";
    nix-fish-src.flake = false;

    azabiong-vim-highlighter.url = "github:azabiong/vim-highlighter";
    azabiong-vim-highlighter.flake = false;

    github-nvim-theme.url = "github:projekt0n/github-nvim-theme";
    github-nvim-theme.flake = false;

    lucid-fish-prompt-src.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt-src.flake = false;

    substitute-nvim-src.url = "github:gbprod/substitute.nvim";
    substitute-nvim-src.flake = false;

    terminal-nvim-src.url = "github:rebelot/terminal.nvim";
    terminal-nvim-src.flake = false;

    mini-nvim-src.url = "github:echasnovski/mini.nvim";
    mini-nvim-src.flake = false;

    spacevimtheme.url = "github:liuchengxu/space-vim-theme";
    spacevimtheme.flake = false;

    vim-js.url = "github:yuezk/vim-js";
    vim-js.flake = false;

    lspfuzzy.url = "github:ojroques/nvim-lspfuzzy";
    lspfuzzy.flake = false;

    yui.url = "github:cidem/yui";
    # yui.url = "path:/Users/fbs/private/yui";
    yui.flake = false;

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
    unstable,
    # unstable-local,
    home-manager,
    flake-utils,
    operatorMono,
    nixpkgs,
    mini-nvim-src,
    lspfuzzy,
    nix-fish-src,
    lucid-fish-prompt-src,
    substitute-nvim-src,
    zig-overlay,
    azabiong-vim-highlighter,
    github-nvim-theme,
    yui,
    spacevimtheme,
    terminal-nvim-src,
    vim-js,
  }: let
    overlays = [
      (final: prev: rec {zigpkgs = zig-overlay.packages.${prev.system};})

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            terminal = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "terminal";
              src = terminal-nvim-src;
            };
          };
      })

      (final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            copilot-vim = prev.vimPlugins.copilot-vim.overrideAttrs (old: {
              postInstall = ''
                substituteInPlace $out/autoload/copilot/agent.vim \
                  --replace "  let node = get(g:, 'copilot_node_command', ''\'''\')" \
                            "  let node = get(g:, 'copilot_node_command', '${prev.nodejs}/bin/node')"
              '';
            });
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            github-nvim-theme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "github-nvim-theme";
              src = github-nvim-theme;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            azabiong-vim-highlighter = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "azabiong-vim-highlighter";
              src = azabiong-vim-highlighter;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            yui = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "yui";
              src = yui;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            substitute = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "substitute";
              src = substitute-nvim-src;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            mini = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "mini";
              src = mini-nvim-src;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            lspfuzzy = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "lspfuzzy";
              src = lspfuzzy;
            };
          };
      })

      (self: super: {
        vimPlugins =
          super.vimPlugins
          // {
            spacevim = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "spacevim";
              src = spacevimtheme;
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
            vim-js = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              version = "latest";
              pname = "vim-js";
              src = vim-js;
            };
          };
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
