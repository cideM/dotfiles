{ ... }:
{
  # prr (https://github.com/danobi/prr) reviews GitHub PRs as a text file and
  # posts the annotations as inline review comments. The package comes from the
  # fork's integration branch (flake input `prr-src`, overlay in 0_setup.nix)
  # until the token_command and review thread changes land upstream.
  #
  # The token is never stored: `token_command` reads it from gh's keychain
  # entry on every run.
  flake.modules.homeManager.prr =
    { pkgs, config, ... }:
    {
      home.packages = [
        pkgs.prr
        pkgs.gh
      ];

      xdg.configFile."prr/config.toml".text = ''
        [prr]
        token_command = "gh auth token"
        workdir = "${config.xdg.dataHome}/prr"
        activate_pr_metadata_experiment = true
      '';
    };
}
