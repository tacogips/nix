{ ... }:
{
  settings.vim.luaConfigRC.telescope = ''
    require("telescope").setup({
      defaults = {
        prompt_prefix = " ❯ ",
        sorting_strategy = "descending",
        layout_config = {
          prompt_position = "bottom",
        },
        mappings = {
          i = {
            ["<ESC>"] = require("telescope.actions").close,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<TAB>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_next,
            ["<C-s>"] = require("telescope.actions").send_selected_to_qflist,
            ["<C-q>"] = require("telescope.actions").send_to_qflist,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
  '';
}
