{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Allow unfree packages system-wide
  nixpkgs.config.allowUnfree = true;

  # Keep flake-based commands such as `nix shell nixpkgs#...` available on
  # Linux hosts without relying on per-user nix.conf edits.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Garbage collection settings
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Store optimization
  nix.settings.auto-optimise-store = true;
}
