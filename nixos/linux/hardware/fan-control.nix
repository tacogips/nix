{ config, lib, pkgs, ... }:

{
  # for fan control
  hardware.i2c = {
    enable = true;
  };

  programs.coolercontrol = {
    enable = true;
  };

  # Add user to i2c group
  users.users.taco.extraGroups = [ "i2c" ];
}