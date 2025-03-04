{ ... }:

{

  plugins.aerial = {
    enable = true;
    #keymaps for telescope , not the global one

    settings = {
      close_on_select = false;
      keymaps = {
        "?" = "actions.show_help";
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
