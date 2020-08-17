# Dotfiles

<!-- vim-markdown-toc GFM -->

* [Setup](#setup)
* [Intro](#intro)
* [Things That Don't Work So Well](#things-that-dont-work-so-well)
* [TODO](#todo)

<!-- vim-markdown-toc -->

There's no place like `~`

## Setup

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

As much as possible is managed through Nix and Home Manager (HM) but especially GUI apps can be problematic. The `stow` folder contains mostly the same configuration as `nix` but in a way that can be used with GNU stow. Think of it as the low-fi way of handling configuration and packages.

## Things That Don't Work So Well

-   Visual Studio Code when installed through Nix requires [patching](https://discourse.nixos.org/t/vs-code-liveshare/7022) for the Liveshare feature to work
    -   [ ] https://github.com/MicrosoftDocs/live-share/issues/3501
    -   [ ] https://github.com/NixOS/nixpkgs/issues/41189
-   Alacritty doesn't work with OpenGL see:
    -   [ ] https://github.com/NixOS/nixpkgs/issues/9415
    -   [x] https://github.com/NixOS/nixpkgs/issues/80702
    -   https://discourse.nixos.org/t/libgl-undefined-symbol-glxgl-core-functions/512/6
-   Anki is a bit old in current `nixpkgs-unstable`
-   Picom installed through Nix has the same issue as Alacritty and fails to start because it can't find GLX extension list
    -   [ ] https://github.com/NixOS/nixpkgs/issues/9415
-   Git when installed through HM on MacOS uses Linux Git which doesn't understand `use_keychain`
    -   [ ] https://github.com/NixOS/nixpkgs/issues/62353
-   [Spotify Desktop](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/instant-messengers/slack/default.nix) file is wrong and needs to mirror [Slack](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/audio/spotify/default.nix#L147)
    -   [ ] TODO: Create a PR
-   I don't know how to type a single `\` right now
    -   [x] https://discourse.nixos.org/t/how-to-write-single-backslash/8604

## TODO

-   [ ] Replace `vim-polyglot` with individual plugins
-   [ ] Clean up init.vim
-   [ ] Try using firefox through Nix
-   [ ] Try using Alacritty through Nix on MacOS
