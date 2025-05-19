{ config, pkgs, lib, ... }:

{
  # Linux-specific Firefox configuration
  programs.firefox = {
    enable = true;
    
    # Basic Firefox settings for Linux
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      
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
      
      # Extensions will be added later once NUR is configured
    };
  };
}