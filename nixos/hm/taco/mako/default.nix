# mako: a notifier for wayland
{ pkgs, lib, ... }:
{
  programs.mako = {
    enable = true;
    defaultTimeout = 5000;
  };
}
