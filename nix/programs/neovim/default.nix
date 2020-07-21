let
  sources = import ../../nix/sources.nix;

  pkgs = (import sources.nixpkgs) { };

  overlay = import ./overlay.nix;

  localPlugins =
    builtins.map
      (pkg: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = pkg;
        version = "latest";
        src = ./. + "/plugins" + ("/" + pkg);
      })
      [
        "clojure"
        "css"
        "dhall"
        "find-utils"
        "format"
        "go"
        "haskell"
        "javascript"
        "jenkinsfile"
        "json"
        "lua"
        "make"
        "markdown"
        "nix"
        "nixpkgs-fmt-neoformat"
        "reflow"
        "rust"
        "sh"
        "typescript"
        "vim"
        "xml"
        "yaml"
        "zen"
      ];

  remotePlugins = with builtins;
    map
      (pkg:
        let
          repoName = elemAt (split ":" pkg.repo) 2;
        in
        pkgs.vimUtils.buildVimPluginFrom2Nix {
          # repo should have colon, so split at that and then get 2nd elements
          # git@github.com:foo/bar -> foo/bar
          pname = elemAt (split "/" repoName) 2;
          version = "latest";
          src = pkg;
        })
      [
        sources.Apprentice
        sources."cocopon/iceberg.vim"
        sources.conjure
        sources.deoplete
        sources.deoplete-lsp
        sources.editorconfig-vim
        sources.fzf
        sources."fzf.vim"
        sources.neoformat
        sources.nord-vim
        sources."sad.vim"
        sources."seoul256.vim"
        sources."targets.vim"
        sources.vim-apathy
        sources.vim-asterisk
        sources.vim-colortemplate
        sources.vim-commentary
        sources.vim-cool
        sources.vim-dirvish
        sources.vim-easy-align
        sources.vim-eunuch
        sources.vim-fugitive
        sources.vim-gutentags
        sources.vim-indent-object
        sources.vim-markdown-folding
        sources.vim-markdown-toc
        sources.vim-matchup
        sources.vim-one
        sources.vim-polyglot
        sources.vim-qf
        sources.vim-repeat
        sources.vim-rhubarb
        sources.vim-sandwich
        sources.vim-sneak
        sources.vim-unimpaired
        sources.yui
        sources.float-preview
      ];

  config = {
    programs.neovim.enable = true;

    programs.neovim.configure = {
      customRC = builtins.readFile ./init.vim;

      packages.n = {
        start = [

          (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
            pname = "parinfer";
            version = "latest";
            postInstall = ''
              rtpPath=$out/share/vim-plugins/${pname}-${version}
              mkdir -p $rtpPath/plugin
              sed "s,let s:libdir = .*,let s:libdir = '${pkgs.parinfer-rust}/lib'," \
                plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
            '';
            src = sources.parinfer;
          })

        ] ++ localPlugins ++ remotePlugins;

        opt = [

          (pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "nvim-lsp";
            version = "latest";
            src = sources.nvim-lsp;
          })

        ];
      };
    };
  };

in
{ inherit overlay config remotePlugins; }
