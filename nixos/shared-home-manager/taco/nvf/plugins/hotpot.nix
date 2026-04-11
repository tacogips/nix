{ pkgs, ... }:
{
  settings.vim.lazy.plugins."hotpot.nvim" = {
    package = pkgs.vimPlugins.hotpot-nvim;
    setupModule = "hotpot";
  };
}
