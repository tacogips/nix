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
          { mode = "n", keys = "<Space>.", desc = "Reload file from disk" },
          { mode = "n", keys = "<Space>w", desc = "Write current file" },
          { mode = "n", keys = "<Space>c", desc = "Copy current directory path" },
          { mode = "n", keys = "<Space>j", desc = "Insert newline below" },
          { mode = "n", keys = "<Space><Space>q", desc = "Force-quit current window" },
          { mode = "n", keys = "<Space>e", desc = "Open yazi file browser" },
          { mode = "n", keys = "<Space>R", desc = "Run current file with QuickRun" },
          { mode = { "n", "x" }, keys = "<Space>p", desc = "Paste system clipboard after" },
          { mode = { "n", "x" }, keys = "<Space>P", desc = "Paste system clipboard before" },
          { mode = { "n", "x" }, keys = "<Space>y", desc = "Yank to system clipboard" },
          { mode = "n", keys = "<Space>Y", desc = "Yank line to system clipboard" },
          { mode = "n", keys = "<Space>C", desc = "Copy current file path" },
          { mode = "n", keys = "<Space>g", desc = "Open LazyGit" },
          { mode = "n", keys = "<Space>G", desc = "Open git branch picker" },
          { mode = "n", keys = "<Space>,", desc = "Open recent files picker" },
          { mode = "n", keys = "<Space>b", desc = "Open buffer picker" },
          { mode = "n", keys = "<Space>f", desc = "Open git files picker" },
          { mode = "n", keys = "<Space>/", desc = "Open live grep picker" },
          { mode = "n", keys = "<Space>m", desc = "Open marks picker" },
          { mode = "n", keys = "<Space>H", desc = "Open command history picker" },
          { mode = "n", keys = "<Space>?", desc = "Open keymap picker" },
          { mode = "n", keys = "<Space>a", desc = "[lsp] Show code actions" },
          { mode = "n", keys = "<Space>s", desc = "[lsp] Open struct symbols picker" },
          { mode = "n", keys = "<Space>S", desc = "[lsp] Open non-struct symbols picker" },
          { mode = "n", keys = "<Space>t", desc = "[lsp] Open document symbols picker" },
          { mode = "n", keys = "<Space>d", desc = "[lsp] Open document diagnostics picker" },
          { mode = "n", keys = "<Space>D", desc = "[lsp] Open workspace diagnostics picker" },
          { mode = "n", keys = "<Space>k", desc = "[lsp] Show hover documentation" },
          { mode = "n", keys = "<Space>r", desc = "[lsp] Rename symbol" },
          { mode = "n", keys = "<Space>\\", desc = "[lsp] Restart LSP" },

          -- Goto namespace
          { mode = "n", keys = "gn", desc = "[lsp] Jump to next diagnostic" },
          { mode = "n", keys = "gp", desc = "[lsp] Jump to previous diagnostic" },
          { mode = "n", keys = "gd", desc = "[lsp] Jump to definition" },
          { mode = "n", keys = "gy", desc = "[lsp] Jump to type definition" },
          { mode = "n", keys = "gr", desc = "[lsp] Open references picker" },
          { mode = "n", keys = "gi", desc = "[lsp] Open implementations picker" },
          { mode = { "n", "x" }, keys = "gj", desc = "Hop jump anywhere" },
          { mode = { "n", "x" }, keys = "gf", desc = "Hop jump on current line" },

          -- Match namespace
          { mode = "n", keys = "mm", desc = "Jump to matching bracket" },
          { mode = "n", keys = "ms", desc = "Add surround" },
          { mode = "n", keys = "mr", desc = "Replace surround" },
          { mode = "n", keys = "md", desc = "Delete surround" },
          { mode = "n", keys = "ma", desc = "Select around textobject" },
          { mode = "n", keys = "mi", desc = "Select inside textobject" },

          -- View namespace
          { mode = "n", keys = "zc", desc = "Center current line" },
          { mode = "n", keys = "zj", desc = "Scroll view down" },
          { mode = "n", keys = "zk", desc = "Scroll view up" },
          { mode = "n", keys = "zm", desc = "Center cursor horizontally" },
        },
        window = {
          delay = 200,
          config = {
            border = "rounded",
            width = 48,
          },
        },
      })
    '';
  };
}
