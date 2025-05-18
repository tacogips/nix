{ config, lib, pkgs, ... }:

{
  # Additional file systems beyond the auto-generated ones
  fileSystems = {
    # 2TB
    # additional /dev/nvme0n1
    "/d" = {
      device = "/dev/disk/by-uuid/f5387897-4ad1-4bb0-ab0f-38024c69e652";
      fsType = "ext4";
    };

    # 4TB
    # additional /dev/nvme2n1p1
    "/g" = {
      device = "/dev/disk/by-uuid/396d04e2-550c-4328-a819-3a11aa50608f";
      fsType = "ext4";
    };
  };

  # Set custom permissions for the additional storage volumes
  system.activationScripts.setDiskPermissions = {
    text = ''
      chown $(id -u taco):$(id -g taco) /d
      chmod 755 /d

      chown $(id -u taco):$(id -g taco) /g
      chmod 755 /g
    '';
    deps = [ ];
  };
}