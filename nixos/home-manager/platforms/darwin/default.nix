{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  
  imports = [
    # NOTE: Create a home.nix file here when you start to configure Darwin
    # ./home.nix
    ../../taco # Import shared configurations
  ];
  
  # Any macOS-specific settings can go here
  # These will only be applied when imported from the Darwin configuration
  
  # TODO: Add Darwin-specific configurations when needed
}