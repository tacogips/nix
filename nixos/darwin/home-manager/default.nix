{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  imports = [
    ./home.nix # Import Darwin-specific home settings
    ./alacritty.nix # Darwin-specific Alacritty configuration
    ./firefox.nix # Darwin-specific Firefox configuration
  ];
}