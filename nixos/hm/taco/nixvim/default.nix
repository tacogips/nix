{ pkgs, lib, ... }:

{
  programs.nixvim = {
    enable = true;
    imports = [
      ./base.nix
      ./plugins
    ];

  };

}
