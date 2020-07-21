#!/bin/sh

root=$(git rev-parse --show-toplevel)

echo "Checking dependencies:"

if ! command -v stow > /dev/null
then
    printf "\tGNU stow missing"
    exit 1
fi

echo ""

cd "$root"/src/ || exit 1

echo "Stowing:"

# Stow a bunch of directories which are the same on all machines
for dir in "$@"
do
    stow --target "$HOME" "$dir"
    printf "\tok %s\n" "$dir"
done

echo ""
