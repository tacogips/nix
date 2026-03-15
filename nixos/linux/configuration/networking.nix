{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.extraHosts = ''
    127.0.0.1 mongo1 mongo2 mongo3
  '';

  # DNS configuration
  networking.nameservers = [
    "8.8.8.8"
    "8.8.4.4"
  ];

  # Consolidated firewall configuration
  networking.firewall = {
    # Enable the firewall
    enable = true;

    # Allow loose reverse path filtering for Tailscale exit nodes
    # This prevents internet connectivity loss when using exit nodes
    checkReversePath = "loose";

    # Allowed TCP ports
    allowedTCPPorts = [
      22 # SSH
      5173 # Vite dev server
      7144 # Dev server
      8384 # Syncthing web UI
      22000 # Syncthing file transfer
    ];

    # Allowed UDP ports
    allowedUDPPorts = [
      21027 # Syncthing discovery
      22000 # Syncthing file transfer
      53 # DNS (for docker)
      config.services.tailscale.port # Tailscale port
    ];

    # Tailscale-specific settings
    trustedInterfaces = [ "tailscale0" ];
  };
}
