{ config, lib, pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  # for xremap
  services.udev.extraRules = ''
    KERNEL=="uinput",GROUP="input", TAG+="uaccess"
  '';

  # Add user to input group for xremap
  users.users.taco.extraGroups = [ "input" ];
}