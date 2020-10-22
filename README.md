# Dotfiles

There's no place like `~`

## Intro

This repository holds the configuration for 3 hosts:

-   Macbook Pro (MBP)
-   NixOS installation on my desktop computer
-   Arch installation on my desktop computer

Each host has a `home.nix` which needs to be available at `~/.config/nixpkgs/home.nix`. For NixOS, there's also a `flake.nix`, which makes everything completely independeny of file locations. Just run `sudo nixos-rebuild switch --flake .` there.

For non-NixOS hosts, `ln -sf ~/dotfiles/nix/hosts/archminimal/home.nix ~/.config/nixpkgs/home.nix` shouldl do the trick, followed by `home-manager switch -b backup`

## Notes

In case your `$PATH` is messed up just set `set -x PATH ~/.nix-profile/bin:$PATH` in the current shell and things should just work given that Home Manager is installed

If Nix complains about something not being in my dotfiles folder even though it definitely is, it's probably because it's not yet added to Git!
