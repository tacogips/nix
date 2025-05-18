{ config, pkgs, ... }:

{
  # This is the main entry point for the home-manager configuration,
  # which can be imported by both Linux and Darwin configurations
  
  imports = [
    ./taco
  ];
  
  # Common Home Manager configuration settings across all platforms can go here
}