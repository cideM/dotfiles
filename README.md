# Dotfiles

This repository contains my Nix dotfiles, which power a NixOS desktop computer
and my Darwin M1 laptop.

Additionally, the repository includes a GitHub workflow for updating my Visual
Studio Code extensions on a regular basis. Which is kind of funny because I
actually use Neovim.

The `hosts` folder is the entrypoint into this repository, whereas the
`modules` folder contains the reusable parts which are then used in either of
the two hosts.

## Activate Config

### MacOS

This builds the MacOS Home Manager configuration and then runs the activation
script. My `/etc/nix/nix.conf` only has `build-users-group = nixbld`, I'm
installing an unstable version of Nix with flake support through my Home
Manager configuration as well.

```
$ nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.work-mbp.activationPackage'"
$ ./result/activate
```

This should work as well after the first, successfull Home Manager activation:

```
$ home-manager build --flake .#work-mbp
```

The `--flake` option isn't documented in the manual but you can find it in
`home-manager --help`.

### NixOS

```
$ sudo nixos-rebuild switch
```

### Notes

Beware `nix-env`! Last time I used it to debug a package and that package stuck
around and prevented newer version of that same package to be installed through
my normal Nix configuration. Somehow I never saw the errors until I actived
`verbose` mode for HM. Then it told me that there's a conflict between this old
`vscode-with-extensions` package and what my config was trying to install. Long
story short: if you use `nix-env` make sure to clean things up afterwards.
