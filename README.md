# Welcome

Nix Flake for my M1 laptop and NixOS desktop computer.

## MacOS (`aarch64-darwin`)

The `nix-shell` command is for the first run, afterwards just run `home-manager`

```shell
$ cat /etc/nix/nix.conf
build-users-group = nixbld
trusted-users = root fbs
...
$ nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.work-m1.activationPackage'"
$ ./result/activate
$ home-manager build --flake .#work-m1
```

## NixOS

`sudo nixos-rebuild switch --flake .`
