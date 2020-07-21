# Dotfiles

There's no place like `~`

## Intro

This repository holds the configuration for 3 hosts:

-   Macbook Pro (MBP)
-   NixOS installation on my desktop computer
-   Arch installation on my desktop computer

Both MBP and Arch have [Home Manager](https://github.com/rycee/home-manager) installed, but only to install `niv` and `lorri` and manage project dependencies with Nix. I do have a `home.nix` for my Arch installation, which works, but right now I don't see a point in mixing Pacman/Yay and Home Manager/Nix for my OS configuration and user packages.

All Nix configuration lives in `/nix`.

There is a lot of duplication right now. For example, I have a separate Neovim `init.vim` under `/nix` and under `/src`. Maybe at some point I'll decide to rely entirely on Nix for these things but for now I'm not willing to make that switch.

## Setup

For MBP and Arch, make sure to install [`minpac`](https://github.com/k-takata/minpac) and GNU stow.

Then just run `./setup` which runs different code depending on the output of `hostname`. For each host, a list of stow directories is specified. These all live in `src/`. All of these folders have a folder structure that makes it easy to `stow` them, so `src/nvim/.config/nvim/init.vim`.

There are other platform specific configurations which are not tracked in this repository, such as Systemd files, or `.desktop` files for Linux display managers.
