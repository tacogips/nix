{ yaziPicker, zellijBin }:

{
  normal = {
    space = {
      w = ":write";
      e = ":reload";
      q = ":buffer-close";
    };

    "," = {
      "," = "file_picker";
      a = "code_action";
      e = "rename_symbol";
      g = "workspace_symbol_picker";
      n = "goto_next_diag";
      p = "goto_prev_diag";
      r = "global_search";
      t = "hover";
      x = "goto_implementation";
      y = "goto_type_definition";
      z = "goto_reference";
    };

    "A-j" = "jump_view_left";
    "A-l" = "jump_view_right";
    "C-y" =
      ":sh ${zellijBin} run -n Yazi -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- ${yaziPicker}/bin/hx-yazi-picker";
  };
}
