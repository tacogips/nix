{ ... }:
{

  plugins.hop = {
    settings = {
      keys = "fdjhklsagqwertyuiopzxcvbnm";
    };

  };

  keymaps = [
    {
      mode = "n";
      key = "f";
      action = "require('hop').hint_char1({ current_line_only = true })";
      lua = true;
    }
    {
      mode = "n";
      key = "r";
      action = "require('hop').hint_char1({})";
      lua = true;
    }
    {
      mode = "v";
      key = "f";
      action = "require('hop').hint_char1({ current_line_only = true })";
      lua = true;
    }
    {
      mode = "v";
      key = "r";
      action = "require('hop').hint_char1({})";
      lua = true;
    }
  ];

}
