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
          "disk#root"
          "disk#d"
          "disk#g"
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
          format = "󰻠 {}";
          exec = "${pkgs.bash}/bin/bash ${./scripts/coolercontrol-load.sh}";
          return-type = "json";
          interval = 3;
          tooltip = true;
        };

        "custom/fcitx5" = {
          format = "A/あ"; # You can use a different icon if preferred
          exec = "${pkgs.fcitx5}/bin/fcitx5-remote -n";
          interval = 1;
          return-type = "json";
          on-click = "${pkgs.fcitx5}/bin/fcitx5-configtool";
          tooltip = false;
          signal = 1;
        };
        
        "disk#root" = {
          format = "/ {used_gb}/{total_gb}GB";
          path = "/";
          interval = 30;
          format-used-gb = "{used;gib;1}";
          format-total-gb = "{total;gib;1}";
          tooltip-format = "/ {used} used out of {total} ({percentage_used}%)";
        };
        
        "disk#d" = {
          format = "/d {used_gb}/{total_gb}GB";
          path = "/d";
          interval = 30;
          format-used-gb = "{used;gib;1}";
          format-total-gb = "{total;gib;1}";
          tooltip-format = "/d {used} used out of {total} ({percentage_used}%)";
        };
        
        "disk#g" = {
          format = "/g {used_gb}/{total_gb}GB";
          path = "/g";
          interval = 30;
          format-used-gb = "{used;gib;1}";
          format-total-gb = "{total;gib;1}";
          tooltip-format = "/g {used} used out of {total} ({percentage_used}%)";
        };
      };

    };
  };

}
