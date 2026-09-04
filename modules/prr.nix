{ ... }:
{
  # prr (https://github.com/danobi/prr) reviews GitHub PRs as a text file and
  # posts the annotations as inline review comments. It wants a config file
  # holding a GitHub token. Instead of storing that anywhere, the wrapper
  # builds a throwaway config per invocation from `gh auth token`, so the
  # token is only ever read from gh's keychain entry.
  flake.modules.homeManager.prr =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "prr";
          runtimeInputs = [
            pkgs.prr
            pkgs.gh
            pkgs.coreutils
          ];
          text = ''
            workdir="''${XDG_DATA_HOME:-$HOME/.local/share}/prr"
            mkdir -p "$workdir"

            cfg="$(mktemp -t prr-config.XXXXXX)"
            trap 'rm -f "$cfg"' EXIT

            printf '[prr]\ntoken = "%s"\nworkdir = "%s"\n' \
              "$(gh auth token)" "$workdir" > "$cfg"

            prr --config "$cfg" "$@"
          '';
        })
      ];
    };
}
