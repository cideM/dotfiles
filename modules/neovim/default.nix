# Plugins I might want to check out
# - https://github.com/akinsho/nvim-toggleterm.lua

args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  cfg = config.programs.neovim;

in
{
  imports = [ (import ./options.nix) ];

  config = {
    # It's broken on Darwin so there it needs to be installed with homebrew
    home.packages = mkIf (cfg.clojure.kondo.enable && pkgs.stdenv.isDarwin == false) [ clj-kondo ];

    xdg.configFile = (import ./ftplugins.nix args);

    programs.neovim = {

      enable = true;

      # https://github.com/nvim-treesitter/nvim-treesitter/blob/a5baf151bd78a88c88078b197657f277bcf06058/lockfile.json
      treesitter = {
        enable = false;
        tsx.rev = "73afadbd117a8e8551758af9c3a522ef46452119";
        ts.rev = "73afadbd117a8e8551758af9c3a522ef46452119";
        nix.rev = "791b5ff0e4f0da358cbb941788b78d436a2ca621";
        yaml.rev = "ab0ce67ce98f8d9cc0224ebab49c64d01fedc1a1";
        go.rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        clojure.rev = "f09652f095be878df8a87a57dcbfa07094316253";
        javascript.rev = "852f11b394804ac2a8986f8bcaafe77753635667";
      };

      haskell = {
        hlint.enable = false;
      };

      ale = {
        enable = false;
      };

      lsp = {
        enable = false;
        backend = "nvim-lsp";
      };

      clojure = {
        enable = true;
        kondo.enable = false;
      };

      telescope = {
        enable = false;
        prefix = "<leader>t";
      };

      # This makes startup time noticeably slow
      completion = {
        enable = false;
        backend = "completion-nvim";
        preview.enable = false;
        # This doesn't seem to work. It only shows for very few items and
        # there's still some other floating completion window that pops up
        float-preview-nvim.enable = false;
      };

      git = {
        committia.enable = false;
        gv.enable = false;
        signify.enable = false;
        messenger.enable = false;
      };

      editor = {
        asterisk = false;
        sneak = true;
        sad = true;
        colorizer = false;
        highlight-current-word = false;
      };

      package = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "master";
        src = config.sources.neovim;
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.tree-sitter ];
      });

      configure = with pkgs.vimPlugins; with (import ./thirdparty.nix args); {
        customRC = (import ./initvim.nix args);

        packages = {
          foobar = {
            start = [

              editorconfig-vim
              targets-vim
              vim-colortemplate
              vim-commentary
              vim-easy-align
              vim-eunuch
              vim-gutentags
              vim-indent-object
              vim-matchup
              vim-peekaboo
              vim-repeat
              vim-sandwich
              vim-unimpaired
              vim-dirvish
              vim-scriptease
              inspecthi

              # Git
              vim-fugitive
              vim-rhubarb

              # Language Tooling
              vim-markdown-folding

              # Languages & Syntax
              purescript-vim
              vim-nix
              dhall-vim
              vim-js
              vim-lua
              yats-vim
              vim-jsx-pretty
              Jenkinsfile-vim-syntax
              haskell-vim
              vim-terraform
              fennel-vim

              # Themes
              apprentice
              vim-colors-github
              yui
              seoul256-vim
              iceberg-vim
              vim-one
              onehalf
              papercolor-theme
              onedark-vim
              jellybeans-vim
              falcon
              vim-kuroi-colors
              vim-nightowl-colors
              vim-tokyonight-colors
              spacevim

            ]
            ++ (import ./ownplugins.nix args)
            ++ (if cfg.treesitter.enable then [
              grammarClojure
              # Doesn't build
              # grammarNix
              grammarGo
              grammarYaml
              grammarTs
              grammarTsx
            ] else [ ])
            ++ (if cfg.completion.enable && cfg.completion.backend == "completion-nvim" then [ completion-nvim completion-buffers completion-tags ] else [ ])
            ++ (if cfg.editor.highlight-current-word then [ vim-illuminate ] else [ ])
            ++ (if cfg.git.committia.enable then [ committia ] else [ ])
            ++ (if cfg.git.signify.enable then [ vim-signify ] else [ ])
            ++ (if cfg.git.gv.enable then [ gv-vim ] else [ ])
            ++ (if cfg.git.messenger.enable then [ git-messenger-vim ] else [ ])
            ++ (if cfg.clojure.enable then [ vim-parinfer ] else [ ])
            ++ (if cfg.editor.asterisk then [ vim-asterisk ] else [ ])
            ++ (if cfg.editor.sneak then [ vim-sneak ] else [ ])
            ++ (if cfg.editor.sad then [ sad ] else [ ])
            ++ (if cfg.telescope.enable then [ plenary popup telescope ] else [ ])
            ++ (if cfg.completion.float-preview-nvim.enable then [ float-preview-nvim ] else [ ]);

            opt = [ ]
              ++ (if cfg.editor.colorizer then [ nvim-colorizer ] else [ ])
              ++ (if cfg.lsp.enable && cfg.lsp.backend == "nvim-lsp" then [ nvim-lsp ] else [ ])
              ++ (if cfg.treesitter.enable then [ nvim-treesitter ] else [ ])
              ++ (if cfg.clojure.kondo.enable || cfg.ale.enable || cfg.haskell.hlint.enable then [ ale ] else [ ])
              ++ (if cfg.clojure.enable then [ conjure ] else [ ])
              # This is necessary so I can still use Deoplete for Clojure which
              # isn't supported by completion-nvim since I use Conjure and no LSP
              ++ (if cfg.completion.enable then [ deoplete-nvim deoplete-lsp ] else [ ]);
          };
        };
      };
    };
  };
}
