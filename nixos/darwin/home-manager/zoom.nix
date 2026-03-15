{ config, pkgs, ... }:

{
  # Zoom video conferencing application for macOS
  home.packages = with pkgs; [
    zoom-us
  ];
}
