#!/bin/sh

yay -Qqettm > pkgs/"$(hostname)"_aur.txt
yay -Qqettn > pkgs/"$(hostname)"_arch.txt
