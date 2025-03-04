{ pkgs, ... }:
{

  #extraPlugins = [ pkgs.vimPlugins.iceberg ];
  #colorscheme = "iceberg";
  colorschemes.tokyonight = {
    enable = true;
  };

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

  vimdiffAlias = true;

  keymaps = [
    {
      mode = "n";
      key = "Q";
      action = "<Nop>";

    }

    {
      mode = "n";
      key = "gQ";
      action = "<Nop>";
    }

    {
      mode = "n";
      key = "<Esc><Esc>";
      action = "set nohlsearch<CR>";
    }

    {
      mode = "n";
      key = "j";
      action = "gj";
    }

    {
      mode = "n";
      key = "k";
      action = "gk";
    }

    {
      mode = "n";
      key = "+";
      action = "g;";
    }

    {
      mode = "n";
      key = "J";
      action = "gJ";
    }

    {
      mode = "n";
      key = "bp";
      action = "bprevious<CR>";
    }

    {
      mode = "n";
      key = "bn";
      action = ":bnext<CR>";
    }

    {
      mode = "n";
      key = "<Space>.";
      action = "<C-u>so $MYVIMRC<CR>";
    }

    {
      mode = "n";
      key = ",w";
      action = "write<CR>";
    }
    #
    {
      mode = "n";
      key = "<Space>w";
      action = ":write<CR>";
    }
    #
    {
      mode = "n";
      key = ".y";
      action = "<C-u>!pwd | wl-copy<CR>";
    }

    #{
    #  mode = "n";
    #  key = "<Space><Space>";
    #  action = "i <Esc><Right>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>j";
    #  action = "i<CR><ESC>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>x";
    #  action = "xi<Space><ESC>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>n";
    #  action = ":bn!<CR>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>b";
    #  action = ":bp!<CR>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>o";
    #  action = ":on!<CR>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>q";
    #  action = ":q!<CR>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<Space>1";
    #  action = ":qa!<CR>";
    #}

    #
    #{
    #  mode = "n";
    #  key = ",e";
    #  action = ":e! %<CR>";
    #}
    #
    #{
    #  mode = "n";
    #  key = ",y";
    #  action = ":tabo<CR>";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<C-l>";
    #  action = "<C-w>l";
    #}
    #
    #{
    #  mode = "n";
    #  key = "<C-h>";
    #  action = "<C-w>h";
    #}
    #
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }

    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }

    {
      mode = "i";
      key = "<C-d>";
      action = "<Delete>";
    }

    {
      mode = "i";
      key = "<C-h>";
      action = "<Bs>";
    }

    {
      mode = "i";
      key = "<C-f>";
      action = "<Right>";
    }

    {
      mode = "i";
      key = "<C-b>";
      action = "<Left>";
    }

    {
      mode = "i";
      key = "kj";
      action = "<ESC><ESC>";
    }

    {
      mode = "i";
      key = "<C-v>";
      action = "<C-R>+";
    }

    {
      mode = "i";
      key = "<ESC>";
      action = "<ESC>:set iminsert=0<CR>";
    }

    {
      mode = "i";
      key = "<C-j>";
      action = "<nop>";
    }

    {
      mode = "v";
      key = "kj";
      action = "<ESC><ESC>";
    }

  ];
}
