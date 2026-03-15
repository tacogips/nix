{ config, lib, pkgs, ... }:

let
  xdg-desktop-portal-gtk-hyprland = pkgs.xdg-desktop-portal-gtk.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      substituteInPlace $out/share/xdg-desktop-portal/portals/gtk.portal \
        --replace-fail "UseIn=gnome" "UseIn=gnome;Hyprland;hyprland;wlroots;sway;Wayfire;river"
    '';
  });
in
{
  # enable screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk-hyprland
    ];
    config.common = {
      default = [ "gtk" ];
    };
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.portal.ScreenCast" = "hyprland";
      "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
      "org.freedesktop.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
    };
  };
}
