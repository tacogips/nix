{ pkgs, ... }:
{
  settings.vim.lazy.plugins.luasnip = {
    package = pkgs.vimPlugins.luasnip;
    after = ''
      require("luasnip.loaders.from_snipmate").load()
    '';
  };
}
