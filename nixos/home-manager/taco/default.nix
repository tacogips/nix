# Default entry point for taco's home-manager configuration
{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
  ];
}