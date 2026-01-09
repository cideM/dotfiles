# Claude Code Notes

## Lix Cache Debugging (January 2026)

### Problem

Lix was building locally (~5 min) instead of being fetched from cache.nixos.org, despite having caches configured in `/etc/nix/nix.conf`.

### Root Cause

1. **Multiple nixpkgs in flake.lock**: When inputs like `neovim-nightly-overlay` don't have `inputs.nixpkgs.follows = "nixpkgs"`, they bring their own nixpkgs, creating multiple versions in the lock file (e.g., `nixpkgs`, `nixpkgs_2`, etc.)
2. **Cache availability varies by commit**: Not all nixpkgs commits have cached aarch64-darwin builds. Hydra's macOS build capacity is limited.
3. **Derivation hash mismatch**: Even the same package version produces different store paths with different nixpkgs commits, so cache hits depend on using a commit that Hydra has built.

### Key Diagnostic Commands

```bash
# Check if a specific store path is in the cache
curl -sI "https://cache.nixos.org/<hash>.narinfo" | head -1
# HTTP/2 200 = cached, HTTP/2 404 = not cached

# Get the store path hash from a package
nix eval --raw '.#homeConfigurations.mbp.config.nix.package.outPath'
# Then extract hash: echo "/nix/store/xxxxx-lix-2.93.3" | sed 's|/nix/store/||' | cut -d'-' -f1

# Check what nix plans to do (fetch vs build)
nix build nixpkgs#lixPackageSets.stable.lix --dry-run
# "will be fetched" = cached, "will be built" = not cached

# List all nixpkgs entries in flake.lock
nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | select(.key | startswith("nixpkgs")) | "\(.key): \(.value.locked.rev // "follows")"'

# Check which nixpkgs the root flake uses
nix flake metadata --json | jq -r '.locks.nodes.root.inputs.nixpkgs'

# Compare Lix paths between your flake and bare nixpkgs
nix eval --raw '.#homeConfigurations.mbp.config.nix.package.outPath'
nix eval --raw 'nixpkgs#lixPackageSets.stable.lix.outPath'
# Different hashes = your flake's nixpkgs differs from registry
```

### Fix: Consolidate nixpkgs inputs

Add `follows` to inputs that bring their own nixpkgs:

```nix
# flake.nix
neovim-nightly-overlay = {
  url = "github:nix-community/neovim-nightly-overlay";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

### Finding a cached nixpkgs commit

```bash
# Check if a specific commit has cached Lix for aarch64-darwin
nix eval --impure --raw --expr 'let np = builtins.getFlake "github:NixOS/nixpkgs/<commit>"; in np.legacyPackages.aarch64-darwin.lixPackageSets.stable.lix.outPath'

# Then check cache status with curl as above

# Pin to a specific commit
nix flake update nixpkgs --override-input nixpkgs github:NixOS/nixpkgs/<commit>
```

### Cache URLs

- `cache.nixos.org` - Official Hydra cache (has nixpkgs builds, limited macOS coverage)
- `cache.lix.systems` - Lix project cache (only has builds from official Lix flake, NOT nixpkgs)

### Notes

- Using Lix from nixpkgs (`pkgs.lixPackageSets.stable.lix`) won't match `cache.lix.systems` - those are different derivations
- macOS (especially aarch64-darwin) has spotty cache coverage on cache.nixos.org
- When debugging cache issues, always verify the exact store path hash matches what's in the cache
