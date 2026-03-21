{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.taco.ghostty;
  ghosttyCommand =
    if cfg.autoStartTmux then
      let
        launchTmux = pkgs.writeShellScript "ghostty-launch-tmux" ''
          session_name="${cfg.tmuxSessionName}-$$-$(${pkgs.coreutils}/bin/date +%s)"
          if ! exec ${pkgs.tmux}/bin/tmux new-session -s "$session_name"; then
            exec ${pkgs.fish}/bin/fish --login
          fi
        '';
      in
      "direct:${launchTmux}"
    else
      "direct:${pkgs.fish}/bin/fish --login";
in
{
  options.taco.ghostty = {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "Gruvbox Dark";
      description = "Ghostty color theme.";
    };

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

    autoStartTmux = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether Ghostty should launch directly into tmux.";
    };

    tmuxSessionName = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Prefix used for tmux session names when Ghostty auto-starts tmux.";
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
      theme = ${cfg.theme}
      font-family = ${cfg.fontFamily}
      font-size = ${toString cfg.fontSize}
      window-padding-x = 5
      window-padding-y = 5
      window-decoration = auto
      shell-integration = fish
      initial-command = ${ghosttyCommand}
      command = ${ghosttyCommand}
      copy-on-select = false
      confirm-close-surface = false
      keybind = alt+s=text:hx\x20
      keybind = chain=write_screen_file:paste,plain
      keybind = chain=text:\r
      ${cfg.extraConfig}
    '';
  };
}
