{ config, pkgs, ... }:

{
  # Linux-specific Home Manager configurations
  
  imports = [
    ../../taco
  ];
  
  # Any Linux-specific settings can go here
  # These will only be applied when imported from the Linux configuration
}