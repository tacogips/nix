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
          # Ghostty can be spawned from inside an existing tmux client.
          # Clear inherited tmux state so each Ghostty instance creates and
          # attaches to its own session instead of reusing the parent client.
          unset TMUX
          unset TMUX_PANE

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
    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
      defaultText = lib.literalExpression ''
        if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty
      '';
      description = "Ghostty package to install. Set to null when managed outside Home Manager.";
    };

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
    home.packages = lib.optional (cfg.package != null) cfg.package;

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
      app-notifications = config-reload
      ${cfg.extraConfig}
    '';
  };
}
