{ pkgs, ... }:
{
  settings.vim.lazy.plugins."mini.clue" = {
    package = pkgs.vimPlugins.mini-clue;
    after = ''
      local miniclue = require("mini.clue")

      miniclue.setup({
        triggers = {
          { mode = { "n", "x" }, keys = "<Space>" },
          { mode = { "n", "x" }, keys = "g" },
          { mode = "n", keys = "m" },
          { mode = "n", keys = "z" },
        },
        clues = {
          -- Space namespace
          { mode = "n", keys = "<Space>.", desc = "Reload current file" },
          { mode = "n", keys = "<Space>w", desc = "Write file" },
          { mode = "n", keys = "<Space>c", desc = "Copy current directory path" },
          { mode = "n", keys = "<Space>j", desc = "Insert newline" },
          { mode = "n", keys = "<Space>e", desc = "Open yazi" },
          { mode = "n", keys = "<Space>R", desc = "QuickRun" },
          { mode = "n", keys = "<Space>t", desc = "Aerial symbols" },
          { mode = { "n", "x" }, keys = "<Space>p", desc = "Paste clipboard after" },
          { mode = { "n", "x" }, keys = "<Space>P", desc = "Paste clipboard before" },
          { mode = { "n", "x" }, keys = "<Space>y", desc = "Yank to clipboard" },
          { mode = "n", keys = "<Space>Y", desc = "Yank line to clipboard" },
          { mode = "n", keys = "<Space>C", desc = "Copy current file path" },
          { mode = "n", keys = "<Space>g", desc = "Git status" },
          { mode = "n", keys = "<Space>G", desc = "Git branches" },
          { mode = "n", keys = "<Space>gc", desc = "Git commits" },
          { mode = "n", keys = "<Space>'", desc = "Recent files" },
          { mode = "n", keys = "<Space>b", desc = "Buffers" },
          { mode = "n", keys = "<Space>f", desc = "Git files" },
          { mode = "n", keys = "<Space>/", desc = "Live grep" },
          { mode = "n", keys = "<Space>m", desc = "Marks" },
          { mode = "n", keys = "<Space>h", desc = "Command history" },
          { mode = "n", keys = "<Space>?", desc = "Keymaps" },
          { mode = "n", keys = "<Space>a", desc = "Code actions" },
          { mode = "n", keys = "<Space>S", desc = "Workspace symbols" },
          { mode = "n", keys = "<Space>s", desc = "Document symbols" },
          { mode = "n", keys = "<Space>d", desc = "Document diagnostics" },
          { mode = "n", keys = "<Space>D", desc = "Workspace diagnostics" },
          { mode = "n", keys = "<Space>k", desc = "Hover" },
          { mode = "n", keys = "<Space>r", desc = "Rename symbol" },
          { mode = "n", keys = "<Space>\\", desc = "Restart LSP" },

          -- Goto namespace
          { mode = "n", keys = "gn", desc = "Next diagnostic" },
          { mode = "n", keys = "gp", desc = "Previous diagnostic" },
          { mode = "n", keys = "gd", desc = "Definition" },
          { mode = "n", keys = "gy", desc = "Type definition" },
          { mode = "n", keys = "gr", desc = "References" },
          { mode = "n", keys = "gi", desc = "Implementations" },
          { mode = { "n", "x" }, keys = "gj", desc = "Hop jump" },
          { mode = { "n", "x" }, keys = "gf", desc = "Hop jump on current line" },

          -- Match namespace
          { mode = "n", keys = "mm", desc = "Matching bracket" },
          { mode = "n", keys = "ms", desc = "Surround add" },
          { mode = "n", keys = "mr", desc = "Surround replace" },
          { mode = "n", keys = "md", desc = "Surround delete" },
          { mode = "n", keys = "ma", desc = "Select around textobject" },
          { mode = "n", keys = "mi", desc = "Select inside textobject" },

          -- View namespace
          { mode = "n", keys = "zc", desc = "View center line" },
          { mode = "n", keys = "zt", desc = "View line at top" },
          { mode = "n", keys = "zb", desc = "View line at bottom" },
          { mode = "n", keys = "zm", desc = "View horizontally center cursor" },
          { mode = "n", keys = "zj", desc = "Scroll view down" },
          { mode = "n", keys = "zk", desc = "Scroll view up" },
        },
        window = {
          delay = 200,
          config = {
            border = "rounded",
          },
        },
      })
    '';
  };
}
