{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix { fontSize = 13; inherit pkgs; })
    (import ../../modules/neovim)
    (import ../../modules/git.nix)
    (import ../../modules/fcitx.nix)
    (import ../../modules/tmux)
    (import ../../modules/ctags.nix)
    (import ../../modules/clojure)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedPackagesLinux.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/goland)
    (import ../../modules/vscode)
  ];

  home.packages = with pkgs; [
    insomnia
    (import ../../derivations/kubectl.nix {
      inherit (pkgs) stdenv;
      inherit (builtins) fetchurl;
    })
    sublime-merge
    spotify
    zoom-us
    slack
    jetbrains.webstorm
    pass
    jetbrains.clion
    jetbrains.rider
    docker-credential-helpers
    anki
    jetbrains.pycharm-professional
  ];

  # On first install this needs to be disabled for allowUnfree to work. I
  # shouldn't have to do this but nothing in
  # https://github.com/rycee/home-manager/issues/463 works
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty.enable = true;

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  home.file.".docker/config.json".text = ''
{
	"auths": {
		"094398396563.dkr.ecr.eu-central-1.amazonaws.com": {}
	},
	"HttpHeaders": {
		"User-Agent": "Docker-Client/19.03.12 (linux)"
	},
	"credsStore": "pass"
}
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';

}
