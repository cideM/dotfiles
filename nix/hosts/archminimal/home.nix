{ pkgs, ... }:
let
  shared = import ../../shared.nix;

  programs = import ../../programs/default.nix;

  clojure = (import ../../languages/clojure/default.nix) { inherit pkgs sources; };

  sources = import ../../nix/sources.nix;

  pkgs = import sources.nixpkgs { };

  fish = programs.fish { inherit pkgs sources; };

  alacrittyYaml = (import ../../programs/alacritty/default.nix { inherit pkgs sources ; }).linux;

in
{
  imports = [
    (programs.nvim { inherit pkgs sources; })
    fish.config
    clojure.config
    programs.fzf.config
    programs.tmux.config
    programs.redshift.config
    (programs.git { inherit pkgs; })
  ];

  home.packages = with pkgs; shared.pkgs ++ [
    iotop
    xclip
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix { inherit pkgs sources; })
  ];

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x SHELL ${pkgs.fish}/bin/fish
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  # https://github.com/rycee/home-manager/blob/master/modules/targets/generic-linux.nix#blob-path
  targets.genericLinux.enable = true;

  # TODO: alacritty.config like with neovim but merge with enable = false
  # https://github.com/NixOS/nixpkgs/issues/9415
  # https://github.com/NixOS/nixpkgs/issues/80702
  # https://discourse.nixos.org/t/libgl-undefined-symbol-glxgl-core-functions/512/6
  programs.alacritty.enable = false;
  xdg.configFile."alacritty/alacritty.yml".text = "${builtins.readFile alacrittyYaml}" + ''
  shell:
    args:
      - "-l"
    program: ${pkgs.fish}/bin/fish
  '';

  services.lorri.enable = true;
  services.lorri.package = pkgs.lorri;

  programs.direnv.enable = true;
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.fzf.enable = true;

  # https://github.com/rycee/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];

  programs.home-manager = {
    enable = true;
  };

  # https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  home.stateVersion = "20.03";
}
