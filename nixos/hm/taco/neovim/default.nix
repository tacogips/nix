{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight = {
    	enable = true;
    };
  };
}
