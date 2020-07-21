# Lots of things are commented out because right now I don't want to have half
# of my programs coming from pacman and the other half from home manager
{ pkgs, ... }:
let
  shared = import ../../shared.nix;

  programs = import ../../programs/default.nix;

  fish = programs.fish { inherit pkgs sources; };

  clojure = (import ../../languages/clojure/default.nix) { inherit pkgs sources; };

  sources = import ../../nix/sources.nix;

  alacrittyYaml = (import ../../programs/alacritty/default.nix { inherit pkgs sources; }).macos;

in
{
  imports = [
    (programs.nvim { inherit pkgs sources; })
    fish.config
    clojure.config
    programs.fzf.config
    programs.tmux.config
    # https://github.com/NixOS/nixpkgs/issues/62353
    # (programs.git.config pkgs)
  ];

  programs.fish.interactiveShellInit = ''
    set -x SHELL ${pkgs.fish}/bin/fish
    set -x FISH_NOTES_DIR ~/.local/share/fish_notes
    set -x FISH_JOURNAL_DIR ~/.local/share/fish_journal

    contains ${pkgs.coreutils}/bin $PATH
    or set -x PATH ${pkgs.coreutils}/bin $PATH/
  '';

  # https://github.com/rycee/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];

  home.packages = with pkgs; shared.pkgs ++ [
    lorri
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix { inherit pkgs sources; })
    (import ../../programs/alacritty/overlay.nix { inherit pkgs sources; })
  ];

  nixpkgs.config = import ../../nixpkgs_config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../../nixpkgs_config.nix;

  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.yml".text = "${builtins.readFile alacrittyYaml}" + ''
    shell:
      args:
        - "-l"
      program: ${pkgs.fish}/bin/fish
  '';

  programs.fzf.enable = true;

  programs.direnv.enable = true;
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;


  programs.home-manager = {
    enable = true;
  };

  home.stateVersion = "20.03";
}
