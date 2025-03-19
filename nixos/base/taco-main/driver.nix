{ config, pkgs, ... }:

{
  # NVIDIA drivers are unfree
  nixpkgs.config.allowUnfree = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  # Enable OpenGL
  hardware = {
    graphics = {
      enable = true;
      #    driSupport = true;
      enable32Bit = true;
    };

    nvidia-container-toolkit.enable = true;

    nvidia = {
      # Modesetting is required for most Wayland compositors
      modesetting.enable = true;

      # Enable power management (recommended)
      powerManagement.enable = true;

      # Use the open source version of the kernel module
      # Only available on driver 515.43.04+
      open = false;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Choose the driver version
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      #prime = {
      #  intelBusId = "PCI:0:2:0";
      #  nvidiaBusId = "PCI:1:0:0";
      #  offload = {
      #    enable = true;
      #    enableOffloadCmd = true;
      #  };
      #};
    };
  };
}
