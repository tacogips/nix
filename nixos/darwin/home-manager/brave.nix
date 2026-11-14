{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Darwin-specific Brave configuration
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

    # Command-line arguments for Brave on macOS
    commandLineArgs = [
      # Privacy and security flags
      "--disable-background-networking"
      "--disable-breakpad"
      "--disable-crash-reporter"
      "--disable-sync"
    ];
  };
}
