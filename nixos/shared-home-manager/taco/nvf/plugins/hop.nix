{ pkgs, ... }:
{
  settings.vim.lazy.plugins."hop.nvim" = {
    package = pkgs.vimPlugins.hop-nvim;
    setupModule = "hop";
    setupOpts.keys = "fdjhklsagqwertyuiopzxcvbnm";
  };
}
