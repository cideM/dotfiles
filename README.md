# Dotfiles

## Intro

This repository holds the configuration for 3 hosts:

-   Macbook Pro (MBP)
-   NixOS installation on my desktop computer
-   Arch installation on my desktop computer

<!-- vim-markdown-toc GFM -->

- [Dotfiles](#dotfiles)
  - [Setup](#setup)
    - [With Flakes (only tested on NixOS so far and not with a clean install)](#with-flakes-only-tested-on-nixos-so-far-and-not-with-a-clean-install)
    - [Without Flakes (on non-NixOS)](#without-flakes-on-non-nixos)
  - [Intro](#intro)
  - [Things That Don't Work So Well](#things-that-dont-work-so-well)

<!-- vim-markdown-toc -->

There's no place like `~`

## Setup

### With Flakes (only tested on NixOS so far and not with a clean install)

`sudo nixos-rebuild switch --flake .` should be all that's necessary from inside the `dotfiles` folder. Need to make sure that experimental flakes feature is installed and that the hardware file is updated.

### Without Flakes (on non-NixOS)

1. Create `~/.config/nixpkgs`: `mkdir -p ~/.config/nixpkgs`
2. `echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix`
    - This will be overwritten by `home-manager switch` but might be necessary on the very first run
3. Symlink `home.nix`: `ln -sf ~/dotfiles/nix/hosts/archminimal/home.nix ~/.config/nixpkgs/home.nix`
4. `home-manager switch -b backup`

In case your `$PATH` is messed up just set `set -x PATH ~/.nix-profile/bin:$PATH` in the current shell and things should just work given that Home Manager is installed
