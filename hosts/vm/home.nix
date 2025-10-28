{
  pkgs,
  home-manager,
  config,
  osConfig,
  ...
}:
{
  imports = [
    (import ../../modules/neovim)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
    (import ../../modules/git.nix)
    (import ../../modules/ghostty.nix)
  ];

  home = {
    stateVersion = "20.09";
    packages = with pkgs; [
      home-manager.packages.aarch64-linux.default
      ghostty
      kanji-stroke-order-font
      wl-clipboard
    ];
    sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };

  programs = {
    gpg.enable = true;

    jujutsu = {
      enable = true;
    };
  };

  home.file = {
    ".claude/anthropic_key.sh" = {
      text = ''
        cat ${osConfig.sops.secrets."claude_api_key".path}
      '';
      executable = true;
    };
  };

}
