# Dotfiles

There's no place like `~`

## Activate Config

### MacOS

This builds the MacOS Home Manager configuration and then runs the activation script. My `/etc/nix/nix.conf` only has `build-users-group = nixbld`, I'm installing an unstable version of Nix with flake support through my Home Manager configuration as well.

```
$ nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.work-mbp.activationPackage'"
$ ./result/activate
```

This should work as well after the first, successfull Home Manager activation:

```
$ home-manager build --flake .#work-mbp
```

The `--flake` option isn't documented in the manual but you can find it in `home-manager --help`.

### NixOS

```
$ sudo nixos-rebuild switch
```

## Visual Studio Code

The URL doesn't change but the sha does, it's annoying. Need to manually set a fake sha, update and then paste the actual sha.

Updating extensions: `cd modules/vscode/; cat shared_exts.txt | ./update_exts.sh > shared_exts.nix`

## TODO

- [ ] Remove `niv` in favor of Flakes for all inputs
- [x] Depending on what new laptop I get, use Flakes for HM as well (or just reuse the NixOS config)

### Notes

Beware `nix-env`! Last time I used it to debug a package and that package stuck
around and prevented newer version of that same package to be installed through
my normal Nix configuration. Somehow I never saw the errors until I actived
`verbose` mode for HM. Then it told me that there's a conflict between this old
`vscode-with-extensions` package and what my config was trying to install. Long
story short: if you use `nix-env` make sure to clean things up afterwards.
