# Dotfiles

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

## Intro

This repository holds the configuration for 3 hosts:

-   Macbook Pro (MBP)
-   NixOS installation on my desktop computer
-   Arch installation on my desktop computer

As much as possible is managed through Nix and Home Manager (HM) but especially GUI apps can be problematic.

## Things That Don't Work So Well

-   Visual Studio Code (VSC) when installed through Nix requires [patching](https://discourse.nixos.org/t/vs-code-liveshare/7022) for the Liveshare feature to work
    -   [ ] https://github.com/MicrosoftDocs/live-share/issues/3501
    -   [ ] https://github.com/NixOS/nixpkgs/issues/41189
-   Alacritty doesn't work with OpenGL on **Arch**:
    -   [ ] https://github.com/NixOS/nixpkgs/issues/9415
    -   [x] https://github.com/NixOS/nixpkgs/issues/80702
    -   https://discourse.nixos.org/t/libgl-undefined-symbol-glxgl-core-functions/512/6
-   Anki is a bit old in current `nixpkgs-unstable`
-   Picom installed through Nix has the same issue as Alacritty **on Arch** and fails to start because it can't find GLX extension list
    -   [ ] https://github.com/NixOS/nixpkgs/issues/9415
-   Git when installed through HM on MacOS uses Linux Git which doesn't understand `use_keychain` -> `brew install git`
    -   [ ] https://github.com/NixOS/nixpkgs/issues/62353
-   [ ] Desktop files aren't picked up on Arch GNOME. Not sure why or rather I have no idea how to add the relevant paths to Gnome
    -   https://github.com/nix-community/home-manager/issues/1439
