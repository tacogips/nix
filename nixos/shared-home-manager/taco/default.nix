# Default entry point for taco's shared home-manager configuration
# (platform-independent settings)
{
  config,
  pkgs,
  homeStateVersion ? "24.11",
  ...
}:

{
  imports = [
    # Import shared modules (no home.nix as it's platform-specific)
    ./bat
    ./bottom
    ./bun
    ./claude
    ./cursor
    ./deno
    ./direnv
    ./eza
    ./fd
    ./fish
    ./fzf
    ./git
    ./go
    ./ghostty
    # ./helix
    ./ign
    ./julia
    ./kinko
    ./lazydocker
    ./lazygit
    ./nvf
    # Temporarily disabled: marktext build fails in nixpkgs (node-gyp not found)
    # Re-enable after upstream/package fix.
    # ./marktext
    ./ripgrep
    ./ssh
    ./tmux
    ./yazi
    # ./zed
    ./zoxide
    ./zellij
    ../extends/mutability
    # Other platform-independent modules can be added here
  ];

  # Common configuration for all platforms
  programs.home-manager.enable = true;

  # Compatibility version: keep the user's first Home Manager release per machine.
  home.stateVersion = homeStateVersion;
}
