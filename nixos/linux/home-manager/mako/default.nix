# mako: a notifier for wayland
{ pkgs, lib, ... }:
{
  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };
}
