{ ... }:

{
  # Keep the existing daemon implementation so routine `switch` does not
  # become a boot-only migration when nixpkgs changes its default.
  services.dbus.implementation = "dbus";
}
