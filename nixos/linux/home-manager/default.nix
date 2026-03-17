{ config, pkgs, ... }:

{
  # Linux-specific Home Manager configurations

  imports = [
    ./home.nix
    ./fish # Import Linux-specific fish functions
    # ./firefox # Import Linux-specific Firefox configuration
    ./brave # Import Linux-specific Brave configuration
    ./alacritty # Import Linux-specific Alacritty configuration
    ../../shared-home-manager/taco # Import shared configurations
  ];

  # Linux-specific user settings
  home.username = "taco";
  home.homeDirectory = "/home/taco";
  taco.yazi.openCommand = "${pkgs.xdg-utils}/bin/xdg-open";

  # Any other Linux-specific settings can go here
  # These will only be applied when imported from the Linux configuration
}
