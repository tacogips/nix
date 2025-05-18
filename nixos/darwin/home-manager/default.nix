{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  
  imports = [
    # NOTE: Create a home.nix file here when you start to configure Darwin
    # ./home.nix
    ../../home-manager/taco # Import shared configurations
  ];
  
  # Darwin-specific user settings
  home.username = "taco";
  home.homeDirectory = "/Users/taco"; # macOS uses /Users instead of /home
  
  # Any other macOS-specific settings can go here
  # These will only be applied when imported from the Darwin configuration
  
  # TODO: Add Darwin-specific configurations when needed
}