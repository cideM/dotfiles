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

      # https://github.com/nvim-treesitter/nvim-treesitter/blob/a5baf151bd78a88c88078b197657f277bcf06058/lockfile.json
      treesitter = {
        enable = true;
        tsx.rev = "73afadbd117a8e8551758af9c3a522ef46452119";
        ts.rev = "73afadbd117a8e8551758af9c3a522ef46452119";
        yaml.rev = "258751d666d31888f97ca6188a686f36fadf6c43";
        go.rev = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
        clojure.rev = "f8006afc91296b0cdb09bfa04e08a6b3347e5962";
      };

      haskell = {
        hlint.enable = true;
      };

      clojure = {
        enable = true;
        kondo.enable = true;
      };

      telescope = {
        enable = false;
        prefix = "<leader>t";
      };

      completion = {
        enable = true;
      };

      git = {
        committia.enable = false;
        gv.enable = false;
        signify.enable = true;
        messenger.enable = true;
      };

      editor = {
        highlight-current-word = false;
      };
      enable = true;

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
              limelight-vim
              sad
              targets-vim
              vim-asterisk
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
              vim-sneak
              vim-unimpaired
              vim-dirvish

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
            ++ (if cfg.treesitter.enable then [ grammarClojure grammarGo grammarYaml grammarTs grammarTsx ] else [ ])
            ++ (if cfg.completion.enable then [ completion-nvim completion-buffers completion-tags ] else [ ])
            ++ (if cfg.editor.highlight-current-word then [ vim-illuminate ] else [ ])
            ++ (if cfg.git.committia.enable then [ committia ] else [ ])
            ++ (if cfg.git.signify.enable then [ vim-signify ] else [ ])
            ++ (if cfg.git.gv.enable then [ gv-vim ] else [ ])
            ++ (if cfg.git.messenger.enable then [ git-messenger-vim ] else [ ])
            ++ (if cfg.clojure.enable then [ conjure vim-parinfer ] else [ ]);

            opt = [
              nvim-colorizer
            ]
            ++ (if cfg.lsp.enable && cfg.lsp.backend == "nvim-lsp" then [ nvim-lsp ] else [ ])
            ++ (if cfg.treesitter.enable then [ nvim-treesitter ] else [ ])
            ++ (if cfg.clojure.kondo.enable || cfg.lsp.ale_integration then [ ale ] else [ ])
            # This is necessary so I can still use Deoplete for Clojure which
            # isn't supported by completion-nvim since I use Conjure and no LSP
            ++ (if cfg.completion.enable then [ deoplete-nvim deoplete-lsp ] else [ ]);
          };
        };
      };
    };
  };
}
