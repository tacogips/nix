{ config, pkgs, ... }:

{
  # Linux-specific Home Manager configurations
  
  imports = [
    ./home.nix
    ../../shared-home-manager/taco # Import shared configurations
  ];
  
  # Linux-specific user settings
  home.username = "taco";
  home.homeDirectory = "/home/taco";
  
  # Any other Linux-specific settings can go here
  # These will only be applied when imported from the Linux configuration
}