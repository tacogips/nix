{ ... }:
{

  plugins.hop = {
    keys = "fdjhklsagqwertyuiopzxcvbnm";

    keymaps = {
      normal = {
        "f" = {
          action = "require('hop').hint_char1({ current_line_only = true })";
          lua = true;
          silent = true;
          noremap = true;
        };

        "r" = {
          action = "require('hop').hint_char1({})";
          lua = true;
          silent = true;
          noremap = true;
        };
      };

      visual = {
        "f" = {
          action = "require('hop').hint_char1({ current_line_only = true })";
          lua = true;
          silent = true;
          noremap = true;
        };

        "r" = {
          action = "require('hop').hint_char1({})";
          lua = true;
          silent = true;
          noremap = true;
        };
      };
    };

  };
}
