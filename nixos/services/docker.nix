{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
      setSocketVariable = false;
    };
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    package = pkgs.nvidia-container-toolkit;
  };

  # deal with container error. setting rlimit type 8: operation not permitted for rootlessdocker
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@wheel";
      type = "hard";
      item = "memlock";
      value = "unlimited";
    }
  ];
}