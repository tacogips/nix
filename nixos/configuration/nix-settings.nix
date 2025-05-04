{ config, lib, pkgs, ... }:

{
  # Allow unfree packages system-wide
  nixpkgs.config.allowUnfree = true;
  
  # Garbage collection settings
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  
  # Store optimization
  nix.settings.auto-optimise-store = true;
}