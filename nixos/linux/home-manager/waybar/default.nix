{ pkgs, ... }:
{
  # Ensure required dependencies for CoolerControl scripts
  home.packages = with pkgs; [
    curl
    jq
  ];

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar.css;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 15;

        modules-left = [
          "hyprland/workspaces"
          "custom/fcitx5"
        ];

        modules-center = [
          "hyprland/window"
          "clock"
        ];

        "clock" = {
          format = "{:%Y-%m-%d (%a) | %H:%M:%S}";
          tooltip-format = "{:%Y-%m-%d (%a) | %H:%M:%S}";
          interval = 1;
          tooltip = true;
        };
        modules-right = [
          "custom/cpu-temp"
          "custom/gpu-temp"
          "custom/cpu-load"
          "memory"
          "custom/disk-root"
          "custom/disk-d"
          "custom/disk-g"
          "network"
        ];
        
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) 󰖩";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "Disconnected 󰖪";
          tooltip-format-wifi = "{essid} | Signal: {signalStrength}% | {ipaddr}";
          tooltip-format-ethernet = "{ifname} | {ipaddr}";
          interval = 5;
        };
        "hyprland/workspaces" = {
          format = "{icon}";
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        "custom/cpu-temp" = {
          format = "cpu:{}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/coolercontrol-temp.sh}";
          return-type = "json";
          interval = 3;
          tooltip = true;
        };

        "custom/gpu-temp" = {
          format = "gpu:{}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/gpu-temp.sh}";
          return-type = "json";
          interval = 3;
          tooltip = true;
        };

        "custom/cpu-load" = {
          format = "cpu: {}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/coolercontrol-load.sh}";
          return-type = "json";
          interval = 3;
          tooltip = true;
        };

        "custom/fcitx5" = {
          format = "{}"; # You can use a different icon if preferred
          exec = "${pkgs.fcitx5}/bin/fcitx5-remote -n";
          interval = 1;
          return-type = "text";
          on-click = "${pkgs.fcitx5}/bin/fcitx5-configtool";
          tooltip = false;
          signal = 1;
        };

        "custom/disk-root" = {
          format = "/ {}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/disk-usage.sh} /";
          return-type = "json";
          interval = 30;
        };

        "custom/disk-d" = {
          format = "/d {}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/disk-usage.sh} /d";
          return-type = "json";
          interval = 30;
        };

        "custom/disk-g" = {
          format = "/g {}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/disk-usage.sh} /g";
          return-type = "json";
          interval = 30;
        };

        "memory" = {
          format = "mem: {used:0.1f}GB/{total:0.1f}GB";
          interval = 5;
          tooltip = true;
        };
      };

    };
  };

}
