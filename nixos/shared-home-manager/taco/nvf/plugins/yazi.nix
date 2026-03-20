{ pkgs, ... }:
{
  settings.vim = {
    keymaps = [
      {
        mode = "n";
        # Zed uses Alt-e for project panel focus. In Neovim, Yazi is the closest
        # project-panel-like file browser, so keep the same chord and open it at
        # the current working directory with `:Yazi cwd`.
        key = "<M-e>";
        action = ":Yazi cwd<CR>";
      }
    ];

    lazy.plugins."yazi.nvim" = {
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
