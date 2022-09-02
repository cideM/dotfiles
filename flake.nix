{
  description = "今日は";

  inputs = rec {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    parinfer-rust.url = "github:eraserhd/parinfer-rust";
    parinfer-rust.flake = false;

    winshift.url = "github:sindrets/winshift.nvim";
    winshift.flake = false;

    lucid-fish-prompt.url = "github:mattgreen/lucid.fish";
    lucid-fish-prompt.flake = false;

    nix-env-fish.url = "github:lilyball/nix-env.fish";
    nix-env-fish.flake = false;

    truezen.url = "github:Pocco81/true-zen.nvim";
    truezen.flake = false;

    rosepine.url = "github:rose-pine/neovim";
    rosepine.flake = false;

    doomonetheme.url = "github:NTBBloodbath/doom-one.nvim";
    doomonetheme.flake = false;

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

  outputs =
    { self
    , unstable
    , home-manager
    , operatorMono
    , nixpkgs
    , lspfuzzy
    , winshift
    , nix-env-fish
    , lucid-fish-prompt
    , neovim-nightly-overlay
    , yui
    , spacevimtheme
    , vim-js
    , doomonetheme
    , rosepine
    , parinfer-rust
    , githubtheme
    , truezen
    }:
    let
      overlays = [
        (self: super: {
          kubectl =
            let
              urls = {
                "aarch64-darwin" = "darwin/amd64";
                "x86_64-linux" = "linux/amd64";
              };
              shas = {
                "aarch64-darwin" = "1jlzrlzn063kq0w6yvrdavfiwpdm7g644yh9xknhaq05pd56l142";
                "x86_64-linux" = "pYlQB/Mx8I0uCC6xJFh2SUlVnzC8xb6uJsOPPickJiw=";
              };
            in
            super.stdenv.mkDerivation rec {
              name = "kubectl";
              version = "1.20.0";
              src = super.fetchurl {
                url = "https://dl.k8s.io/release/v${version}/bin/${urls."${super.system}"}/kubectl";
                sha256 = shas."${super.system}";
              };
              dontConfigure = true;
              dontUnpack = true;
              dontBuild = true;
              installPhase = ''
                mkdir -p $out/bin
                cp $src $out/bin/kubectl
              '';
            };
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
          truezen = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "truezen"; src = truezen; };
        })

        (self: super: {
          doomonetheme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "doomonetheme"; src = doomonetheme; };
        })

        (self: super: {
          rosepine = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "rosepine"; src = rosepine; };
        })

        (self: super: {
          githubtheme = super.pkgs.vimUtils.buildVimPluginFrom2Nix rec { version = "latest"; pname = "githubtheme"; src = githubtheme; };
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
              nixpkgs.overlays = overlays ++ [
                # neovim-nightly-overlay.overlay
              ];

              nixpkgs.config = {
                allowUnfree = true;
              };
            }
            ./hosts/fbs-work.local/home.nix
          ];
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
              nixpkgs.overlays = overlays ++ [
                neovim-nightly-overlay.overlay
              ];
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
        unstable.lib.nixosSystem { inherit system modules specialArgs; };
    in
    {
      # TODO: https://github.com/mjlbach/nix-dotfiles/blob/master/nixpkgs/flake.nix
      nixosConfigurations.nixos = desktop;
      inherit homeConfigurations;
    };
}
