# Getting Started

```shell
$ nix-shell -p lix --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.work-m1.activationPackage'"
$ ./result/activate
$ nh home switch . -c work-m1
```
