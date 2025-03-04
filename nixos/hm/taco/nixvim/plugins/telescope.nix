{ ... }:
{

  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
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
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";

      };
    };

    #keymaps for telescope , not the global one
    keymaps =
      {
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
