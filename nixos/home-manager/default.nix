{ config, pkgs, ... }:

{
  # This is the main entry point for the home-manager configuration,
  # which can be imported by both Linux and Darwin configurations
  
  # No direct imports here - let the platform-specific modules handle it
  # The platform configurations will import from ./taco for shared configs
  # and add their platform-specific settings
  
  # Common Home Manager configuration settings across all platforms can go here
}