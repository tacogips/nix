{ config, lib, pkgs, ... }:

{
  # Set the permitCertUid option for the tailscale service
  tacoSystem.tailscale.permitCertUid = "taco";
}