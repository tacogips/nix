{ ... }:

{

  plugins.hop = {
    enable = true;
    settings = {
      keys = "fdjhklsagqwertyuiopzxcvbnm";
    };

  };

  keymaps = [
    {
      mode = "n";
      key = "f";
      action.__raw = "require('hop').hint_char1({ current_line_only = true })";
    }
    {
      mode = "n";
      key = "r";
      action.__raw = "require('hop').hint_char1({})";
    }
    {
      mode = "v";
      key = "f";
      action.__raw = "require('hop').hint_char1({ current_line_only = true })";
    }
    {
      mode = "v";
      key = "r";
      action.__raw = "require('hop').hint_char1({})";
    }
  ];
}
