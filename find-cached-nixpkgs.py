#!/usr/bin/env python3
"""Find the newest nixpkgs commit where Lix is cached for aarch64-darwin using Hydra."""

import argparse
import json
import subprocess
import sys
import urllib.request


def fetch_json(url):
    """Fetch JSON from a URL, following redirects."""
    req = urllib.request.Request(url, headers={
        "User-Agent": "find-cached-nixpkgs",
        "Accept": "application/json"
    })
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())


def get_latest_successful_build():
    """Query Hydra for the latest successful lix build on aarch64-darwin."""
    # This endpoint redirects to the actual build
    url = "https://hydra.nixos.org/job/nixpkgs/unstable/lix.aarch64-darwin/latest-finished"
    req = urllib.request.Request(url, headers={
        "User-Agent": "find-cached-nixpkgs",
        "Accept": "application/json"
    })

    # Follow redirect manually to get the build ID
    with urllib.request.urlopen(req) as resp:
        final_url = resp.geturl()
        return json.loads(resp.read()), final_url


def get_eval_inputs(eval_id):
    """Get the nixpkgs commit for an evaluation."""
    data = fetch_json(f"https://hydra.nixos.org/eval/{eval_id}")
    return data.get("jobsetevalinputs", {})


def main():
    parser = argparse.ArgumentParser(
        description="Find newest nixpkgs commit with cached Lix for aarch64-darwin"
    )
    parser.add_argument("--update", action="store_true",
                        help="Automatically run nix flake update")
    parser.add_argument("--json", action="store_true",
                        help="Output as JSON")
    args = parser.parse_args()

    # Get latest successful build
    print("Querying Hydra for latest successful lix.aarch64-darwin build...", file=sys.stderr)
    build, build_url = get_latest_successful_build()

    # Get the nixpkgs commit from one of the evaluations
    eval_ids = build.get("jobsetevals", [])
    if not eval_ids:
        print("Error: No evaluations found for this build", file=sys.stderr)
        sys.exit(1)

    inputs = get_eval_inputs(eval_ids[0])
    nixpkgs_input = inputs.get("nixpkgs", {})
    commit = nixpkgs_input.get("revision")

    if not commit:
        print("Error: Could not find nixpkgs commit", file=sys.stderr)
        sys.exit(1)

    # Extract store path from build outputs
    outputs = build.get("buildoutputs", {})
    store_path = outputs.get("out", {}).get("path", "unknown")

    result = {
        "commit": commit,
        "build_id": build.get("id"),
        "build_url": build_url,
        "nixname": build.get("nixname"),
        "timestamp": build.get("timestamp"),
        "store_path": store_path,
    }

    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print(f"\nLatest successful Lix build for aarch64-darwin:")
        print(f"  Build:      {result['build_url']}")
        print(f"  Package:    {result['nixname']}")
        print(f"  Store path: {result['store_path']}")
        print(f"  Commit:     {result['commit']}")

        cmd = f"nix flake update nixpkgs --override-input nixpkgs github:NixOS/nixpkgs/{commit}"

        if args.update:
            print(f"\nRunning: {cmd}")
            subprocess.run(cmd, shell=True)
        else:
            print(f"\nTo update your flake:")
            print(f"  {cmd}")


if __name__ == "__main__":
    main()
