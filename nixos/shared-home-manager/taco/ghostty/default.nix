{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.taco.ghostty;
in
{
  options.taco.ghostty = {
    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "iosevka";
      description = "Ghostty font family.";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 11;
      description = "Ghostty font size.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional Ghostty configuration appended after the shared defaults.";
    };
  };

  config = {
    home.packages = [ pkgs.ghostty ];

    xdg.configFile."ghostty/config".text = ''
      theme = Catppuccin Mocha
      font-family = ${cfg.fontFamily}
      font-size = ${toString cfg.fontSize}
      window-padding-x = 5
      window-padding-y = 5
      window-decoration = auto
      shell-integration = fish
      command = ${pkgs.fish}/bin/fish --login
      copy-on-select = false
      confirm-close-surface = false
      keybind = alt+s=write_screen_file:open
      ${cfg.extraConfig}
    '';
  };
}
