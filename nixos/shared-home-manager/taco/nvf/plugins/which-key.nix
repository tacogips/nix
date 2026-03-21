{ pkgs, ... }:
{
  settings.vim.lazy.plugins."which-key.nvim" = {
    package = pkgs.vimPlugins.which-key-nvim;
    after = ''
      local wk = require("which-key")

      wk.setup({
        preset = "helix",
        delay = 200,
        win = {
          border = "rounded",
          width = 48,
        },
        plugins = {
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = false,
            nav = false,
            z = false,
            g = false,
          },
        },
        filter = function(mapping)
          return mapping.desc ~= nil and mapping.desc ~= ""
        end,
        triggers = {
          { "<Space>", mode = { "n", "x" } },
          { "g", mode = { "n", "x" } },
          { "m", mode = { "n" } },
          { "z", mode = { "n" } },
        },
      })
    '';
  };
}
