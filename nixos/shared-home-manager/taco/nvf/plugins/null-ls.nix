{ pkgs, mkLuaInline, ... }:
{
  settings.vim.lazy.plugins.null-ls-nvim = {
    package = pkgs.vimPlugins.null-ls-nvim;
    setupModule = "null-ls";
    setupOpts.sources = mkLuaInline ''
      {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
      }
    '';
  };
}
