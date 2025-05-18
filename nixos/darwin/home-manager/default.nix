{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  imports = [
    ./home.nix # Import Darwin-specific home settings
  ];
}