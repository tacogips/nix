{ pkgs, ... }:
{
  settings.vim = {
    keymaps = [
      {
        mode = "n";
        key = "<Space>e";
        action = ":Yazi<CR>";
      }
    ];

    lazy.plugins.yazi-nvim = {
      package = pkgs.vimPlugins.yazi-nvim;
      setupModule = "yazi";
      setupOpts = {
        open_for_directories = true;
        floating_window_scaling_factor = 0.9;
        yazi_floating_window_border = "rounded";
        yazi_floating_window_winblend = 0;
      };
    };
  };
}
