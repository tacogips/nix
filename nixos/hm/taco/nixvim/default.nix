{ pkgs, lib, ... }:

{

  programs.nixvim = {

    imports = [
      ./base-config.nix
      ./plugins
    ];

    enable = true;

    vimdiffAlias = true;

  };

}
