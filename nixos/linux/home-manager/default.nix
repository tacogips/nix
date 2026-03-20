{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Linux-specific Home Manager configurations

  imports = [
    ./home.nix
    ./fish # Import Linux-specific fish functions
    # ./firefox # Import Linux-specific Firefox configuration
    ./brave # Import Linux-specific Brave configuration
    ../../shared-home-manager/taco # Import shared configurations
  ];

  # Linux-specific user settings
  home.username = "taco";
  home.homeDirectory = "/home/taco";
  taco.yazi.openCommand = "${pkgs.xdg-utils}/bin/xdg-open";
  taco.ghostty.autoStartTmux = true;
  taco.ghostty.fontSize = 11;
  programs.zellij.extraConfig = lib.mkAfter ''
    keybinds {
        shared_except "locked" {
            bind "Alt f" { ToggleFocusFullscreen; }
        }
    }
  '';

  # Any other Linux-specific settings can go here
  # These will only be applied when imported from the Linux configuration
}
