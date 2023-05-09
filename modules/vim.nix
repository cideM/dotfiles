args @ {
  config,
  lib,
  pkgs,
  ...
}: {
  programs.vim = {
    enable = true;
    extraConfig = ''
    set vb
    set tw=72
    set com=b:#,:%,n:>
    set list
    set lcs=tab:»·
    set lcs+=trail:·
    '';
    plugins = with pkgs.vimPlugins; [vim-sensible];
  };
}
