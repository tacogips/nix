# This module integrates the shared Home Manager configuration
{ config, pkgs, ... }:

{
  imports = [
    # Point to the new Home Manager configuration
    ../../home-manager/taco/home.nix
  ];
}