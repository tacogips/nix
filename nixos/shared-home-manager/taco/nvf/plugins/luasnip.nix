{ ... }:
{
  settings.vim.luaConfigRC.luasnip = ''
    require("luasnip.loaders.from_snipmate").load()
  '';
}
