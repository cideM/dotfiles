# Dotfiles

There's no place like `~`

## Activate Config

### MacOS

This builds the MacOS Home Manager configuration and then runs the activation script. My `/etc/nix/nix.conf` only has `build-users-group = nixbld`, I'm installing an unstable version of Nix with flake support through my Home Manager configuration as well.

```
$ nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#mbp'"
$ ./result/activate
```

This should work as well after the first, successfull Home Manager activation:

```
$ nix build .#mbp
```

### NixOS

```
$ sudo nixos-rebuild switch
```

## TODO

- [ ] Remove `niv` in favor of Flakes for all inputs
- [x] Depending on what new laptop I get, use Flakes for HM as well (or just reuse the NixOS config)
