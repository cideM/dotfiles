{
  description = "今日は";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    import-tree.url = "github:vic/import-tree";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig-overlay.url = "github:mitchellh/zig-overlay";

    github-markdown-toc-go-src = {
      url = "github:ekalinin/github-markdown-toc.go";
      flake = false;
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix-fish-src.url = "github:kidonng/nix.fish";
    nix-fish-src.flake = false;

    janet-vim.url = "github:janet-lang/janet.vim";
    janet-vim.flake = false;

    nvim-alabaster-scheme-src.url = "github:p00f/alabaster.nvim";
    nvim-alabaster-scheme-src.flake = false;

    vim-js.url = "github:yuezk/vim-js";
    vim-js.flake = false;

    # yui.url = "path:/home/fbrs/private/yui";
    # yui.url = "path:/Users/fbs/private/yui";
    yui.url = "github:cidem/yui";
    yui.flake = true;

    operatorMono = {
      url = "git+ssh://git@github.com/cidem/operatormono?ref=main";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
