#!/bin/sh

brew list > pkgs/"$(hostname)".txt
brew cask list > pkgs/"$(hostname)"_cask.txt
