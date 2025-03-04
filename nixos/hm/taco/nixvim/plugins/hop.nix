{ ... }:
{

  plugins.hop = {
    enable = true;
    settings = {
      keys = "fdjhklsagqwertyuiopzxcvbnm";
    };

  };

  ## TODO use jaction.__raw
  keymaps = [
    {
      mode = "n";
      key = "f";
      action = "<cmd>lua require('hop').hint_char1({ current_line_only = true })<CR>";
    }
    {
      mode = "n";
      key = "r";
      action = "<cmd>lua require('hop').hint_char1({})<CR>";
    }
    {
      mode = "v";
      key = "f";
      action = "<cmd>lua require('hop').hint_char1({ current_line_only = true })<CR>";
    }
    {
      mode = "v";
      key = "r";
      action = "<cmd>lua require('hop').hint_char1({})<CR>";
    }
  ];
}
