{ pkgs, lib, ... }:

{
  programs.nixvim = {
    imports = [
      ./base-config.nix
      ./plugins
    ];

    colorschemes.tokyonight = {
      enable = true;
    };

    enable = true;
    vimdiffAlias = true;
  };

}
