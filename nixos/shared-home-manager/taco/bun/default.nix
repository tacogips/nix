# Bun - JavaScript runtime and toolkit
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bun
  ];
}
