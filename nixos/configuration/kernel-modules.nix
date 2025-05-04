{ config, lib, pkgs, ... }:

{
  # Combine all kernel modules needed by different services
  boot.kernelModules = [
    "uinput"   # for xremap
    "nct6775"  # Nuvoton NCT6798D Super IO sensor for fan control
  ];
}