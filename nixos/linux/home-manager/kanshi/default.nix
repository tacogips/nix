{ pkgs, ... }:
{
  # kanshi - Dynamic display configuration manager for Wayland
  # Automatically applies monitor layouts based on connected displays
  services.kanshi = {
    enable = true;

    # Monitor layout profiles
    # Use 'hyprctl monitors' to check current monitor configuration
    profiles = {
      # Triple monitor setup: 2 monitors on top, 1 below left
      # Physical layout:
      #   [HDMI-A-1]  [DP-3]
      #   [DP-2]
      triplemonitor = {
        outputs = [
          # Top left: HDMI-A-1 (Dell S2721QS)
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
            mode = "3840x2160";
            scale = 1.5;
          }
          # Top right: DP-3 (Dell S2721QS)
          {
            criteria = "DP-3";
            status = "enable";
            position = "2560,0"; # 3840/1.5 = 2560 logical pixels (width of HDMI-A-1)
            mode = "3840x2160";
            scale = 1.5;
          }
          # Bottom left: DP-2 (HP 27f 4k) - directly below HDMI-A-1
          {
            criteria = "DP-2";
            status = "enable";
            position = "0,1440"; # Aligned with HDMI-A-1 left edge, Height: 2160/1.5 = 1440
            mode = "3840x2160";
            scale = 1.5;
          }
        ];
      };

      # Dual monitor setup: vertical stack
      # Physical layout:
      #   [HDMI-A-1]
      #     [DP-2]
      dualmonitor = {
        outputs = [
          # Upper: HDMI-A-1
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
            mode = "3840x2160";
            scale = 1.5;
          }
          # Lower: DP-2
          {
            criteria = "DP-2";
            status = "enable";
            position = "0,1440"; # 2160/1.5 = 1440 logical pixels (height of HDMI-A-1)
            mode = "3840x2160";
            scale = 1.5;
          }

        ];
      };

      # Single monitor profile: DP-2 only (HP 27f 4k)
      dp2only = {
        outputs = [
          {
            criteria = "DP-2";
            status = "enable";
            mode = "3840x2160";
            scale = 1.5;
          }
        ];
      };

      # Single monitor profile: HDMI-A-1 only (Dell S2721QS)
      hdmionly = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "3840x2160";
            scale = 1.5;
          }
        ];
      };
    };
  };
}
