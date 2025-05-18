{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  
  imports = [
    # NOTE: Create a home.nix file here when you start to configure Darwin
    # ./home.nix
    ../../taco # Import shared configurations
  ];
  
  # Darwin-specific user settings (commented out until Darwin is set up)
  # home.username = "taco";
  # home.homeDirectory = "/Users/taco"; # macOS uses /Users instead of /home
  
  # Any other macOS-specific settings can go here
  # These will only be applied when imported from the Darwin configuration
  
  # TODO: Add Darwin-specific configurations when needed
}