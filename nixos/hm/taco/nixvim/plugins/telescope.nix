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

  keymaps = [

    {
      mode = "n";
      key = ",.";
      action.__raw = "require'telescope.builtin'.git_status{}";
    }

    {
      mode = "n";
      key = ",c";
      action.__raw = "require'telescope.builtin'.git_commits{}";
    }

    {
      mode = "n";
      key = ",,";
      action = "<CMD>:Telescope oldfiles<CR>";
    }

    {
      mode = "n";
      key = ",b";
      action.__raw = "require'telescope.builtin'.buffers{}";
    }

    {
      mode = "n";
      key = ",f";
      action.__raw = "require'telescope.builtin'.git_files{}";
    }

    {
      mode = "n";
      key = ",g";
      action.__raw = "require'telescope.builtin'.live_grep{}";
    }

    {
      mode = "n";
      key = ",l";
      action.__raw = "require'telescope.builtin'.git_branches{}";
    }

    {
      mode = "n";
      key = ",m";
      action.__raw = "require'telescope.builtin'.marks{}";
    }

    {
      mode = "n";
      key = ",h";
      action.__raw = "require'telescope.builtin'.command_history{}";
    }

    {
      mode = "n";
      key = ",k";
      action.__raw = "require'telescope.builtin'.keymaps{}";
    }

    {
      mode = "n";
      key = ",z";
      action.__raw = "require'telescope.builtin'.lsp_references{}";
    }

    {
      mode = "n";
      key = ",x";
      action.__raw = "require'telescope.builtin'.lsp_implementations{}";
    }

  ];

}
