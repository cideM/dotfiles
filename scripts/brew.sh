#!/bin/sh

# https://discourse.nixos.org/t/migrating-from-homebrew-to-nix-for-osx/2892

brew leaves > pkgs/"$(hostname)".txt
brew cask list > pkgs/"$(hostname)"_cask.txt
