{ pkgs, config, ... }:
{

  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim)
    (import ../../modules/git.nix)
    (import ../../modules/sources.nix)
    (import ../../modules/redshift.nix)
    (import ../../modules/fcitx.nix)
    (import ../../modules/tmux)
    (import ../../modules/ctags.nix)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedPackagesLinux.nix)
    (import ../../modules/sharedSettings.nix)
  ];

  sources = import ../../nix/sources.nix;

  home.sessionVariables =
    {
      # https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
      # This pkg does not exist for darwin
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };

  programs.fish.shellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  # https://github.com/rycee/home-manager/blob/master/modules/targets/generic-linux.nix#blob-path
  targets.genericLinux.enable = true;
  targets.genericLinux.extraXdgDataDirs = [ "/usr/share" "/usr/local/share" ];

  services.lorri.enable = true;

  programs.alacritty = {
    enable = false;
    fontSize = 13;
  };

  xdg.mime.enable = true;

  fonts.fontconfig.enable = true;

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';
}
