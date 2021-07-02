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

## TODO

- [ ] Remove `niv` in favor of Flakes for all inputs
- [x] Depending on what new laptop I get, use Flakes for HM as well (or just reuse the NixOS config)
