{ config, lib, pkgs, ... }:

{
  networking.extraHosts = ''
    127.0.0.1 mongo1 mongo2 mongo3
  '';

  # Consolidated firewall configuration
  networking.firewall = {
    # Enable the firewall
    enable = true;
    
    # Allowed TCP ports
    allowedTCPPorts = [
      22    # SSH
      8384  # Syncthing web UI
      22000 # Syncthing file transfer
    ];
    
    # Allowed UDP ports
    allowedUDPPorts = [
      21027 # Syncthing discovery
      22000 # Syncthing file transfer
      53    # DNS (for docker)
      config.services.tailscale.port # Tailscale port
    ];
    
    # Tailscale-specific settings
    trustedInterfaces = [ "tailscale0" ];
  };
}