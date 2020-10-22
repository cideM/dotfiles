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

There's also a `stow` directory which contains a very small subset of critical applications I want on all my machines. I can use this as an alternative to managing my global or user environment with Nix. In other words: this is your regular dotfiles setup where the OS package manager installs most things and application specific package managers do the rest. Use like so:

```shell
$ stow --dir stow --target $HOME -S nvim
```

Requires [minpac](https://github.com/k-takata/minpac) and [fisher](https://github.com/jorgebucaran/fisher)
