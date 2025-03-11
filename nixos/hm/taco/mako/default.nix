# mako: a notifier for wayland
{ pkgs, lib, ... }:
{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };
}
