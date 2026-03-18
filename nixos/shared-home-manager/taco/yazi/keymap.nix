{
  manager.prepend_keymap = [
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
