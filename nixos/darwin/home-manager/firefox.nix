{ config, pkgs, lib, ... }:

{
  # Darwin-specific Firefox configuration
  programs.firefox = {
    enable = true;
    
    # Use regular Firefox package on macOS
    # If you have issues, consider using the firefox-bin package from the 
    # nixpkgs-firefox-darwin overlay in the future
    
    profiles = {
      default = {
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
          
          # macOS specific settings
          "widget.macos.touchbar.enabled" = true;
          
          # Performance settings
          "browser.cache.disk.enable" = true;
          "browser.cache.memory.enable" = true;
        };
        
        # Add extensions from the nur repository
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
          bitwarden
        ];
      };
    };
  };
}