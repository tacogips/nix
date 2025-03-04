{ pkgs, ... }:
{

  extraConfigVim = builtins.readFile ./extraconfig.vim;

  opts = {

    autochdir = true;
    wildmenu = true;
    wildmode = "list:full";
    history = 2000;
    errorbells = false;
    visualbell = true;
    title = true;
    undofile = false;
    backup = false;
    swapfile = false;

    shortmess = "atI";
    showmatch = true;
    number = true;
    cursorline = true;
    termguicolors = true;

    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 0;

    autoread = true;

    wrapscan = true;
    ignorecase = true;
    smartcase = true;
    magic = true;

  };

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  #extraPlugins = [ pkgs.vimPlugins.iceberg ];
  #colorscheme = "iceberg";
  colorschemes.tokyonight = {
    enable = true;
  };
  #
  enable = true;
  vimdiffAlias = true;

  #  config = {
  #    globals = {
  #      hybrid_custom_term_colors = 1;
  #      hybrid_reduced_contrast = 1;
  #      #      python_host_prog = "${pkgs.python2}/bin/python";
  #      python3_host_prog = "${pkgs.python3}/bin/python3";
  #    };
  #
  #    clipboard = {
  #      register = "unnamedplus";
  #      providers.wl-copy.enable = true;
  #    };
  #
  #    #    options = {
  #    #      autochdir = true;
  #    #      wildmenu = true;
  #    #      wildmode = "list:full";
  #    #      history = 2000;
  #    #      errorbells = false;
  #    #      visualbell = true;
  #    #      title = true;
  #    #      undofile = false;
  #    #      backup = false;
  #    #      swapfile = false;
  #    #
  #    #      shortmess = "atI";
  #    #      showmatch = true;
  #    #      number = true;
  #    #      cursorline = true;
  #    #      termguicolors = true;
  #    #
  #    #      tabstop = 2;
  #    #      shiftwidth = 2;
  #    #      softtabstop = 0;
  #    #
  #    #      autoread = true;
  #    #
  #    #      wrapscan = true;
  #    #      ignorecase = true;
  #    #      smartcase = true;
  #    #      magic = true;
  #    #    };
  #
  #  };
  #
  ### TODO use jaction.__raw

  keymaps = [
    {
      mode = "n";
      key = "Q";
      action = "<Nop>";

    }
  ];
}
