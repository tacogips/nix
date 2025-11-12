{ config, pkgs, lib, ... }:

{
  # Linux-specific Brave configuration
  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    # Brave/Chromium extensions
    # Note: Extensions are installed via Chrome Web Store IDs
    extensions = [
      # Bitwarden - Password Manager
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # Vimium - Keyboard navigation
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
      # MetaMask - Crypto wallet
      { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; }
      # Ghostery - Privacy and security
      { id = "mlomiejdfkolichcflejclcbmpeaniij"; }
      # Web Clipper for Obsidian
      { id = "cnjifjpddelmedmihgijeibhnjfabmlf"; }
    ];

    # Command-line arguments for Brave
    commandLineArgs = [
      # Wayland support - fixes crashes when moving windows between workspaces
      # See: https://github.com/brave/brave-browser/issues/49862
      "--ozone-platform=wayland"
      "--disable-features=WaylandWpColorManagerV1"

      # Privacy and security flags
      "--disable-background-networking"
      "--disable-breakpad"
      "--disable-crash-reporter"
      "--disable-sync"

      # Performance flags
      "--enable-features=VaapiVideoDecoder"
      "--use-gl=desktop"
    ];
  };
}
