{
  config,
  lib,
  pkgs,
  ...
}:

# Define module options
with lib;
let
  cfg = config.tacoSystem.tailscale;
in
{
  # Define our module options
  options.tacoSystem.tailscale = {
    permitCertUid = mkOption {
      type = types.str;
      default = "root";
      description = "User that is permitted to manage Tailscale certificates";
    };
  };

  config = {
    # Enable the Tailscale service
    services.tailscale = {
      enable = true; # Enable the Tailscale service
      openFirewall = true; # Automatically open firewall ports for Tailscale
      permitCertUid = cfg.permitCertUid; # Permit specified user to manage Tailscale certificates
      useRoutingFeatures = "client"; # Use routing features as a client
      authKeyFile = "/var/lib/tailscale/authkey"; # Path to auth key file
      extraSetFlags = [ "--exit-node-allow-lan-access" ]; # Allow LAN access when using exit nodes
    };

    # Create tailscale group and setup proper file permissions
    users.groups.tailscale = { };

    # Add the tailscale package to the system environment
    environment.systemPackages = with pkgs; [ tailscale ];
  };
}
