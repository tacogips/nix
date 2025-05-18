{ config, pkgs, ... }:

{
  # Darwin-specific Home Manager configurations
  # These settings are now defined in the flake.nix to avoid conflicts
  
  # Import shared user configurations
  imports = [
    # This is now handled in the flake.nix to avoid duplication
  ];
  
  # Add any Darwin-specific packages or configurations below
  # Homebrew is configured at the system level
  
  # Example: Additional macOS-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];
}