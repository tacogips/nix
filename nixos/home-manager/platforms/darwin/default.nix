{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  
  imports = [
    ../../taco
  ];
  
  # Any macOS-specific settings can go here
  # These will only be applied when imported from the Darwin configuration
}