{ config, lib, pkgs, ... }:

{
  # Enable the Tailscale service
  services.tailscale = {
    enable = true;            # Enable the Tailscale service
    openFirewall = true;      # Automatically open firewall ports for Tailscale
    permitCertUid = "taco";   # Permit user "taco" to manage Tailscale certificates
    useRoutingFeatures = "client"; # Use routing features as a client
  };

  # Add the tailscale package to the system environment
  environment.systemPackages = with pkgs; [ tailscale ];
}