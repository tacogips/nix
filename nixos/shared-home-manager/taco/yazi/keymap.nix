{
  manager.prepend_keymap = [
    {
      on = "<Enter>";
      run = "plugin enter-directory";
      desc = "Enter directory in terminal or open file";
    }
    {
      on = [
        ","
        "r"
      ];
      run = "search --via=rg";
      desc = "Search files with ripgrep";
    }
  ];
}
