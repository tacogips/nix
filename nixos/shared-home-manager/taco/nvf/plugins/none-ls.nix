{ pkgs, mkLuaInline, ... }:
{
  settings.vim.lazy.plugins."none-ls.nvim" = {
    package = pkgs.vimPlugins.none-ls-nvim;
    setupModule = "null-ls";
    setupOpts.sources = mkLuaInline ''
      {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.completion.spell,
      }
    '';
  };
}
