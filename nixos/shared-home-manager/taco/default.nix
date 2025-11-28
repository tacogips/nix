# Default entry point for taco's shared home-manager configuration
# (platform-independent settings)
{ config, pkgs, ... }:

{
  imports = [
    # Import shared modules (no home.nix as it's platform-specific)
    ./alacritty
    ./bat
    ./bottom
    ./claude
    ./deno
    ./direnv
    ./eza
    ./fd
    ./fish
    ./fzf
    ./git
    ./go
    ./lazygit
    ./marktext
    ./ripgrep
    ./ssh
    ./zed
    ./zoxide
    ./zsh
    ../extends/mutability
    # Other platform-independent modules can be added here
  ];

  # Common configuration for all platforms
  programs.home-manager.enable = true;

  # Only keep the state version here as it should be consistent across platforms
  home.stateVersion = "24.11";
}
