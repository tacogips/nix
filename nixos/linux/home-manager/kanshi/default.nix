{ pkgs, ... }:
{
  # kanshi の設定
  services.kanshi = {
    enable = true;

    # hyprctl monitors
    profiles = {
      triplemonitor = {
        outputs = [
          # bottom center
          {
            criteria = "DP-2";
            status = "enable";
            position = "0,1440"; # logical height
            mode = "3840x2160";
            scale = 1.5;
          }
          # top left
          {
            criteria = "DP-3";
            status = "enable";
            position = "0,0";
            mode = "3840x2160";
            scale = 1.5;
          }
          # top right
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "2560,0"; # logical width of DP-3
            mode = "3840x2160";
            scale = 1.5;
          }
        ];
      };

      dualmonitor = {
        outputs = [
          # upper
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
            mode = "3840x2160";
            scale = 1.5;
          }
          # lower
          {
            criteria = "DP-2";
            status = "enable";
            position = "0,1440"; # logical height
            mode = "3840x2160";
            scale = 1.5;
          }

        ];
      };

      # for single monitor 1
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

      # for single monitor 2
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
