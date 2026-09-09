# The primary purpose of this module is to create a `pkgs` set, which should
# then be used by all other modules, including Home Manager. This gives me a
# straight forward way to apply overlays to entire configuration.
# It also sets up the systems and the devShell for this repository, because I
# don't know where else to put these.
{ inputs, ... }:
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem =
    { system, ... }:
    let
      overlays = [
        inputs.claude-code.overlays.default

        (final: prev: rec { zigpkgs = inputs.zig-overlay.packages.${prev.system}; })

        # (final: prev: {
        #   inherit (prev.lixPackageSets.stable)
        #     nixpkgs-review
        #     nix-eval-jobs
        #     nix-fast-build
        #     colmena
        #     ;
        # })

        (final: prev: {
          jrnl = prev.jrnl.overridePythonAttrs (old: {
            doCheck = false;
          });
        })

        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            janet-vim = prev.vimUtils.buildVimPlugin {
              version = "latest";
              pname = "janet-vim";
              src = inputs.janet-vim;
            };
            # Same source as the prr package below, so syntax and binary agree.
            prr-vim = prev.vimUtils.buildVimPlugin {
              pname = "prr-vim";
              version = inputs.prr-src.shortRev;
              src = "${inputs.prr-src}/vim";
            };
          };
        })

        # prr from the fork's integration branch (see flake.nix). importCargoLock
        # needs no hash while every dependency comes from crates.io. Bump with
        # `nix flake update prr-src`.
        (final: prev: {
          prr = prev.prr.overrideAttrs (old: {
            src = inputs.prr-src;
            cargoDeps = prev.rustPlatform.importCargoLock {
              lockFile = "${inputs.prr-src}/Cargo.lock";
            };
          });
        })
      ];

      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = overlays;
        config.allowUnfree = true;
      };

    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          janet
          jpm
          nixfmt
          prettier
          lua-language-server
          lua
          stylua
          home-manager
        ];
      };

      _module.args.pkgs = pkgs;
    };
}
