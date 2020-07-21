# Dotfiles

There's no place like `~`

## Intro

This repository holds the configuration for 3 hosts:

-   Macbook Pro (MBP)
-   NixOS installation on my desktop computer
-   Arch installation on my desktop computer

Both MBP and Arch have [Home Manager](https://github.com/rycee/home-manager) installed and manage as many programs and configuration options as possible through Nix.

The Nix configuration lives in `/nix`, but there's also `/src` which holds the stowable configuration. All of these folders have a folder structure that makes it easy to `stow` them, so `src/nvim/.config/nvim/init.vim`.

## Setup

For MBP and Arch, make sure to install [`minpac`](https://github.com/k-takata/minpac) and GNU stow.

Then just run `./setup` which runs different code depending on the output of `hostname`.

There are other platform specific configurations which are not tracked in this repository, such as Systemd files, or `.desktop` files for Linux display managers.

## `pkgs`

The files inside `pkgs` hold information about the native packages on each host which **I would install if I didn't have Nix**. That's just in case something breaks so I can just re-install the native packages.
