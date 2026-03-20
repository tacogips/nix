{ pkgs, ... }:
{
  settings.vim.lazy.plugins.toggleterm-nvim = {
    package = pkgs.vimPlugins.toggleterm-nvim;
    setupModule = "toggleterm";
    setupOpts = { };
  };
}
