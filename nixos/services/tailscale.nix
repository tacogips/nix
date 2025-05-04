{ config, lib, pkgs, ... }:

# Allow parameters to be passed to this module
{ permitCertUid ? "root" }: # Default to "root" if not specified

{
  # Enable the Tailscale service
  services.tailscale = {
    enable = true;            # Enable the Tailscale service
    openFirewall = true;      # Automatically open firewall ports for Tailscale
    permitCertUid = permitCertUid;   # Permit specified user to manage Tailscale certificates
    useRoutingFeatures = "client"; # Use routing features as a client
  };

  # Add the tailscale package to the system environment
  environment.systemPackages = with pkgs; [ tailscale ];
}