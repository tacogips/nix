# Default entry point for taco's shared home-manager configuration
# (platform-independent settings)
{ config, pkgs, ... }:

{
  imports = [
    # Import shared modules (no home.nix as it's platform-specific)
    ./alacritty
    ./bottom
    ./claude
    ./eza
    ./direnv
    ./fd
    ./git
    ./lazygit
    ./ripgrep
    ./fish
    ./ssh
    ./zed
    ./zoxide
    ./bat
    ./fzf
    # Other platform-independent modules can be added here
  ];
  
  # Common configuration for all platforms
  programs.home-manager.enable = true;
  
  # Only keep the state version here as it should be consistent across platforms
  home.stateVersion = "24.11";
}