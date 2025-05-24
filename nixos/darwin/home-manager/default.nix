{ config, pkgs, lib, ... }:

{
  # Darwin-specific Home Manager configurations
  
  imports = [
    ./home.nix   # Import Darwin-specific home settings
    ../../shared-home-manager/taco # Import shared configurations
  ];
  
  # Darwin-specific user settings
  home.username = lib.mkForce "taco";
  home.homeDirectory = lib.mkForce "/Users/taco";
  home.stateVersion = lib.mkForce "24.11";
  
  # Override any shared settings that need customization for macOS
  programs.git = {
    userName = lib.mkForce "tacogips";
    userEmail = lib.mkForce "me+darwin@tacogips.me";
  };
}