{ pkgs, ... }:
{
  settings.vim.lazy.plugins.git-blame-nvim = {
    package = pkgs.vimPlugins.git-blame-nvim;
    setupModule = "gitblame";
    setupOpts.enabled = false;
  };
}
