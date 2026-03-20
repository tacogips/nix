{ pkgs, ... }:
{
  settings.vim.lazy.plugins.hotpot-nvim = {
    package = pkgs.vimPlugins.hotpot-nvim;
    setupModule = "hotpot";
    setupOpts = {
      provide_require_fennel = false;
      enable_hotpot_diagnostics = true;
      compiler.macros.env = "_COMPILER";
    };
  };
}
