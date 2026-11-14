{
  config,
  pkgs,
  lib,
  firefox-addons,
  ...
}:

# Note: We're using explicit parameters (firefox-addons) rather than accessing via inputs.firefox-addons.
# This is a deliberate choice for clarity and maintainability, making dependencies explicit.
# While we could have used the inputs approach (inputs.firefox-addons.packages.${pkgs.system}),
# the explicit parameter approach is more maintainable and clearer about dependencies.

{
  # Linux-specific Firefox configuration
  programs.firefox = {
    enable = true;

    # Firefox policies for basic settings and extensions not in NUR
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;

      # Extensions not available in NUR repository
      ExtensionSettings = {
        # Pontem Aptos Wallet
        "pontem-aptos-wallet@pontem.network" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pontem-aptos-wallet/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };

    # Basic Firefox settings for Linux
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # Configure Firefox extensions from NUR
      extensions.packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        # Privacy and security
        ghostery
        # Password management
        bitwarden
        # Keyboard navigation
        vimium
        # Crypto wallets
        metamask
        # Note taking & web clipping
        web-clipper-obsidian
        # Add more extensions as needed
      ];

      # Additional extensions can be added either through NUR packages above
      # or through Firefox policies for extensions not available in NUR

      # Force settings created in this configuration
      settings = {
        # Set Firefox as the default browser
        "browser.shell.checkDefaultBrowser" = false;

        # Privacy settings
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;

        # Performance settings
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;

        # Keyboard shortcuts customization
        # Make Ctrl+N open a new tab instead of a new window
        "browser.tabs.newTabShortcut" = true;
      };
    };
  };
}
