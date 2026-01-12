# Claude Code Notes

## Updating nixpkgs with Cached Lix

### Problem

Running `nix flake update` can result in Lix building locally (~5 min) because aarch64-darwin has limited cache coverage on Hydra.

### Solution

Use `find-cached-nixpkgs.py` to update to the newest nixpkgs commit where Lix is cached:

```bash
./find-cached-nixpkgs.py           # Show latest cached commit
./find-cached-nixpkgs.py --update  # Update flake automatically
./find-cached-nixpkgs.py --json    # Machine-readable output
```

The script queries Hydra's API for the latest successful `lix.aarch64-darwin` build and extracts the nixpkgs commit.

### Quick Check Tools

```bash
# Check Lix build status on Hydra
nix run nixpkgs#hydra-check -- lix --arch aarch64-darwin

# Check if a store path is cached
curl -sI "https://cache.nixos.org/<hash>.narinfo" | head -1
# HTTP/2 200 = cached, HTTP/2 404 = not cached
```

### Consolidating nixpkgs Inputs

Flake inputs that bring their own nixpkgs can cause cache misses. Add `follows`:

```nix
neovim-nightly-overlay = {
  url = "github:nix-community/neovim-nightly-overlay";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Check for multiple nixpkgs in flake.lock:

```bash
nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | select(.key | startswith("nixpkgs")) | "\(.key): \(.value.locked.rev // "follows")"'
```
