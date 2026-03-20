{ pkgs, mkLuaInline, ... }:
{
  settings.vim.lazy.plugins.telescope-nvim = {
    package = pkgs.vimPlugins.telescope-nvim;
    setupModule = "telescope";
    after = ''
      require("telescope").load_extension("aerial")
    '';
    setupOpts = {
      defaults = {
        prompt_prefix = " ❯ ";
        sorting_strategy = "descending";
        layout_config.prompt_position = "bottom";
        mappings.i = {
          "<ESC>" = mkLuaInline ''require("telescope.actions").close'';
          "<C-j>" = mkLuaInline ''require("telescope.actions").move_selection_next'';
          "<C-k>" = mkLuaInline ''require("telescope.actions").move_selection_previous'';
          "<TAB>" =
            mkLuaInline ''require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_next'';
          "<C-s>" = mkLuaInline ''require("telescope.actions").send_selected_to_qflist'';
          "<C-q>" = mkLuaInline ''require("telescope.actions").send_to_qflist'';
        };
      };
      extensions = {
        aerial.show_nesting = true;
        fzf = {
          fuzzy = true;
          override_generic_sorter = true;
          override_file_sorter = true;
          case_mode = "smart_case";
        };
      };
    };
  };
}
