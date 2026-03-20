{ pkgs, ... }:
{
  settings.vim.lazy.plugins.crates-nvim = {
    package = pkgs.vimPlugins.crates-nvim;
    setupModule = "crates";
    setupOpts.null_ls = {
      enabled = true;
      name = "crates.nvim";
    };
  };
}
