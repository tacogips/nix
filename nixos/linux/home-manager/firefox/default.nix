{ config, pkgs, lib, firefox-addons, ... }:

# Note: We're using explicit parameters (firefox-addons) rather than accessing via inputs.firefox-addons.
# This is a deliberate choice for clarity and maintainability, making dependencies explicit.
# While we could have used the inputs approach (inputs.firefox-addons.packages.${pkgs.system}),
# the explicit parameter approach is more maintainable and clearer about dependencies.

{
  # Linux-specific Firefox configuration
  programs.firefox = {
    enable = true;
    
    # Firefox policies for basic settings
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
    };
    
    # Basic Firefox settings for Linux
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      
      # Configure Firefox extensions from NUR
      extensions = with firefox-addons.packages.${pkgs.system}; [
        # Add desired extensions - uncomment or add as needed
        ublock-origin
        # darkreader
        # bitwarden
        # privacy-badger
        # add more extensions as needed
      ];
      
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
      };
    };
  };
}