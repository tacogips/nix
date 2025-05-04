{ config, lib, pkgs, ... }:

{
  programs.fish.enable = true;

  users.users.taco = {
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      # "input" and "i2c" groups are added in their respective service modules
    ];
    openssh.authorizedKeys.keyFiles = [
      ../ssh/authorized-keys-dev-machine
    ];
  };
}