{ config, pkgs, ... }:

{
  # This is the main entry point for the shared, platform-independent
  # home-manager configuration, which is imported by both Linux and Darwin configurations
  
  # This file is intentionally minimalist. It should NOT contain any platform-specific settings.
  # Platform-specific configurations are in `/linux/home-manager` and `/darwin/home-manager`.
  
  # The platform configurations will import the shared modules from ./taco
  # But we don't import anything here to avoid circular imports.
  
  # If there are truly cross-platform settings that aren't in any module,
  # they could be defined here, but prefer adding them to specific modules when possible.
}