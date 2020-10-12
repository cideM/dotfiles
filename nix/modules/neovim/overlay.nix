{ pkgs, ... }:

final: prev:

{
  wrapNeovim = pkgs.wrapNeovim;

  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    patches = oldAttrs.patches ++ ''
      diff --git a/runtime/lua/vim/treesitter/highlighter.lua b/runtime/lua/vim/treesitter/highlighter.lua
      index 0f497fe43..d84fd2198 100644
      --- a/runtime/lua/vim/treesitter/highlighter.lua
      +++ b/runtime/lua/vim/treesitter/highlighter.lua
      @@ -75,6 +75,7 @@ function TSHighlighter.new(query, bufnr, ft)
         self.edit_count = 0
         self.redraw_count = 0
         self.line_count = {}
      +  print(vim.inspect(self.parser:parse()))
         self.root = self.parser:parse():root()
         a.nvim_buf_set_option(self.buf, "syntax", "")
    '';
  });
}
