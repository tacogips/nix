{ pkgs, lib, ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };
  };
}
