{
  config = {
    # TODO Get path to fd from Nix
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f 2> /dev/null";
      fileWidgetCommand = "fd --type f 2> /dev/null";
      fileWidgetOptions = [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
      changeDirWidgetCommand = "fd --type d 2> /dev/null";
      changeDirWidgetOptions = [ "--preview 'exa -T {} | head -200'" ];
    };
  };
}
