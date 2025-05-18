{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  home.username = "taco";
  home.homeDirectory = "/Users/taco";
  home.stateVersion = "24.11";
  
  # Import shared user configurations
  imports = [
    ../../home-manager/taco
  ];
  
  # Add any Darwin-specific packages or configurations below
  # Homebrew is configured at the system level
  
  # Example: Additional macOS-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];
}