# Dotfiles

There's no place like `~`

## Intro

This repository holds the configuration for 3 hosts:

-   Macbook Pro (MBP)
-   NixOS installation on my desktop computer

Each host has a `home.nix` which needs to be available at `~/.config/nixpkgs/home.nix`. For NixOS, there's also a `flake.nix`, which makes everything completely independeny of file locations. Just run `sudo nixos-rebuild switch --flake .` there.

For non-NixOS hosts, `ln -sf ~/dotfiles/nix/hosts/archminimal/home.nix ~/.config/nixpkgs/home.nix` shouldl do the trick, followed by `home-manager switch -b backup`

## Notes

- In case your `$PATH` is messed up just set `set -x PATH ~/.nix-profile/bin:$PATH` in the current shell and things should just work given that Home Manager is installed
- If Nix flakes complains about something not being in my dotfiles folder even though it definitely is, it's probably because it's not yet added to Git!
- Installing from scratch in Fish can be a bit finnicky. When you run the `./install` script it outputs the path to a script you need to source. Easiest thing is to just start a bash shell, source that script, then run the initial Home Manager setup command.
- On MacOS if the `/nix` resource is busy, just restart and it should be unmountable, in case you want to start from scratch
- Home Manager needs `<nixpkgs>`. Check if you have this defined in both root and user channels. Not sure how this works but long story short: if it seems like your packages our outdated, it's probably because you have more than one `<nixpkgs>` and it's using the wrong one

## TODO

- [ ] Remove `niv` in favor of Flakes for all inputs
- [ ] Depending on what new laptop I get, use Flakes for HM as well (or just reuse the NixOS config)
