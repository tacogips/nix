{ pkgs, ... }:
{
  # kanshi の設定
  services.kanshi = {
    enable = true;

    profiles = {
      dualmonitor = {
        outputs = [
          # lower
          {
            criteria = "DP-2";
            status = "enable";
            position = {
              x = 0;
              y = 1080;
            }; # 下側に配置
            mode = "3840x2160";
            scale = 1.5;
          }
          # upper
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = {
              x = 0;
              y = 0;
            }; # 上側に配置
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
