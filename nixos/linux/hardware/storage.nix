{ config, lib, pkgs, ... }:

{
  # Additional disk mounts are defined in ./.private/private.nix.
  fileSystems = { };

  # Set custom permissions for the additional storage volumes
  system.activationScripts.setDiskPermissions = {
    text = ''
      if [ -d /d ]; then
        chown $(id -u taco):$(id -g taco) /d
        chmod 755 /d
      fi

      if [ -d /g ]; then
        chown $(id -u taco):$(id -g taco) /g
        chmod 755 /g
      fi
    '';
    deps = [ ];
  };
}
