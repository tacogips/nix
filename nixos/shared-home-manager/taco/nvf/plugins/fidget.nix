{ pkgs, ... }:
{
  settings.vim.lazy.plugins."fidget.nvim" = {
    package = pkgs.vimPlugins.fidget-nvim;
    setupModule = "fidget";
    setupOpts = { };
  };
}
