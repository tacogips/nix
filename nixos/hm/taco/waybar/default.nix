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
        position = "bottom";
        layer = "top";
        height = 15;

        modules-left = [ "hyprland/workspaces" ];
        modules-right = [
          "custom/cpu-temp"
          "custom/cpu-load"
          "cpu"
          "memory"
          "disk"
          "custom/disk-d"
          "custom/disk-g"
          "custom/fcitx5"
          "network"
          "clock"
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
        };

        "custom/cpu-temp" = {
          format = "󰔏 {}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/coolercontrol-temp.sh}";
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

        "disk" = {
          format = "/ {used_gb}/{total_gb}GB";
          path = "/";
          interval = 30;
          format-used-gb = "{used;gib;1}";
          format-total-gb = "{total;gib;1}";
          tooltip-format = "/ {used} used out of {total} ({percentage_used}%)";
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
      };

    };
  };

}
