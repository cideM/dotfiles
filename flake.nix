{
  description = "今日は";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    stable.url = "github:NixOS/nixpkgs/nixos-21.11";

    cidem-vsc.url = "github:cideM/visual-studio-code-insiders-nix";

    parinfer-rust.url = "github:eraserhd/parinfer-rust";
    parinfer-rust.flake = false;

    kubectl-nix.url = "github:cidem/kubectl-nix";

    winshift.url = "github:sindrets/winshift.nvim";
    winshift.flake = false;

    lucid-fish-prompt.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt.flake = false;

    nix-env-fish.url = "github:lilyball/nix-env.fish";
    nix-env-fish.flake = false;

    k9s.url = "github:derailed/k9s";
    k9s.flake = false;

    doomonetheme.url = "github:NTBBloodbath/doom-one.nvim";
    doomonetheme.flake = false;

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

  outputs =
    { self
    , unstable
    , home-manager
    , operatorMono
    , nixpkgs
    , lspfuzzy
    , winshift
    , k9s
    , nix-env-fish
    , lucid-fish-prompt
    , cidem-vsc
    , neovim-nightly-overlay
    , yui
    , spacevimtheme
    , vim-js
    , doomonetheme
    , parinfer-rust
    , kubectl-nix
    , stable
    }:
    let
      overlays = [
        (self: super: {
          kubectl = kubectl-nix.packages.${super.system}."1_20_4";
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
          yui = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "yui"; src = yui; };
        })

        (self: super: {
          doomonetheme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "doomonetheme"; src = doomonetheme; };
        })

        (self: super: {
          lspfuzzy = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "lspfuzzy"; src = lspfuzzy; };
        })

        (self: super: {
          spacevim = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "spacevim"; src = spacevimtheme; };
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
          vim-js = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "vim-js"; src = vim-js; };
        })
      ];

      pkgsCompat = import unstable {
        system = "x86_64-darwin";
      };

      pkgsStable = import stable {
        system = "aarch64-darwin";
      };

      specialArgs = {
        inherit home-manager nix-env-fish lucid-fish-prompt;
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
                ./modules/regs.nix
                {
                  nixpkgs.overlays = overlays ++ [
                    neovim-nightly-overlay.overlay
                    (self: super: rec { kitty = pkgsCompat.kitty; })
                    (self: super: rec { aws-mfa = pkgsStable.aws-mfa; })
                    (self: super: rec { qmk = pkgsStable.qmk; })
                    (self: super: rec { alacritty = pkgsCompat.alacritty; })
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
            ./modules/regs.nix
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays ++ [ neovim-nightly-overlay.overlay ];
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
