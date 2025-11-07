# Getting Started

```shell
$ echo "use flake" > .envrc
$ direnv allow
$ nix-shell -p lix --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.mbp.activationPackage'"
$ ./result/activate
$ nh home switch . -c mbp
```

## Architecture

My configuration follows the [Dendritic](https://vic.github.io/dendrix/Dendritic.html) configuration pattern. Every file in `modules/*.nix` is a [*flake parts* module](https://flake.parts/options/flake-parts-modules.html) (not a standard Home Manager or NixOS module!). By using [`import-tree`](https://github.com/vic/import-tree) all modules are automagically imported and active.

Each module should, in theory, deal with a single cross cutting concern, such as configuring Git on all systems, hosts and platforms.

Since I only use Nix on my MacBook Pro, my configuration stuffs most settings into a `modules/common.nix` file.
