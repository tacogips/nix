{ ... }:
{

  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
        settings = {
          override_generic_sorter = true;
          override_file_sorter = true;
          #case_mode = "smart_case";
          case_mode = "ignore_case";
        };
      };
      ui-select = {
        enable = true;
      };

    };

    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";

        #keymaps for telescope , not the global one
        mappings = {

          i = {
            "<ESC>".__raw = "require('telescope.actions').close";
            "<C-j>".__raw = "require('telescope.actions').move_selection_next";
            "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
            "<TAB>".__raw = "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next";
            "<C-s>".__raw = "require('telescope.actions').send_selected_to_qflist";
            "<C-q>".__raw = "require('telescope.actions').send_to_qflist";
          };

        };

      };
    };

  };

  #keymaps = [
  #  {
  #    mode = "n";
  #    key = "f";
  #    action.__raw = "require('hop').hint_char1({ current_line_only = true })";
  #  }
  #  {
  #    mode = "n";
  #    key = "r";
  #    action.__raw = "require('hop').hint_char1({})";
  #  }
  #  {
  #    mode = "v";
  #    key = "f";
  #    action.__raw = "require('hop').hint_char1({ current_line_only = true })";
  #  }
  #  {
  #    mode = "v";
  #    key = "r";
  #    action.__raw = "require('hop').hint_char1({})";
  #  }
  #];
}
