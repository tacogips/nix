{ config, pkgs, ... }:

{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Enable OpenGL
  hardware = {
    graphics = {
      enable = true;
      #    driSupport = true;
      enable32Bit = true;
    };

    nvidia = {
      # Modesetting is required for most Wayland compositors
      modesetting.enable = true;

      # Enable power management (recommended)
      powerManagement.enable = true;

      # Use the open source version of the kernel module
      # Only available on driver 515.43.04+
      open = true;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Choose the driver version
      # Changed from beta to stable to fix driver/library version mismatch
      # Error: "Failed to initialize NVML: Driver/library version mismatch
      # NVML library version: 570.144"
      package = config.boot.kernelPackages.nvidiaPackages.stable;
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