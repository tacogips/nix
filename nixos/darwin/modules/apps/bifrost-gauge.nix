{
  config,
  lib,
  pkgs,
  user ? "taco",
  ...
}:

let
  cfg = config.taco.darwin.apps.bifrost-gauge;
  label = "com.local.bifrost-gauge.bifrost";
  bifrostHost = pkgs.writeShellApplication {
    name = "bifrost-gauge-bifrost-host";
    runtimeInputs = [
      pkgs.bash
      pkgs.coreutils
      pkgs.nix
    ];
    text = ''
      set -euo pipefail

      export PATH="/etc/profiles/per-user/${user}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

      if command -v kinko >/dev/null 2>&1; then
        eval "$(kinko export bash --shared-only --force --confirm=false)"
      fi

      cd ${lib.escapeShellArg cfg.repoRoot}
      exec nix run .#bifrost-host
    '';
  };
in
{
  options.taco.darwin.apps.bifrost-gauge = {
    enable = lib.mkEnableOption "Bifrost Gauge installed with Homebrew Cask";

    repoRoot = lib.mkOption {
      type = lib.types.str;
      default = "/Users/${user}/gits/tacogips/ai-budget-manager";
      description = "Local bifrost-gauge repository used to start Bifrost.";
    };

    startBifrostAtLogin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start the local Bifrost HTTP host through a user LaunchAgent.";
    };

    logDir = lib.mkOption {
      type = lib.types.str;
      default = "/Users/${user}/Library/Logs/bifrost-gauge";
      description = "Directory for Bifrost LaunchAgent stdout and stderr logs.";
    };
  };

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      casks = [
        {
          name = "tacogips/tap/bifrost-gauge";
          # Bifrost Gauge's private cask currently ships an unsigned,
          # unnotarized app. Keep the Gatekeeper workaround scoped to this app.
          postinstall = "app=/Applications/bifrost-gauge.app; if [ -d $app ]; then /usr/bin/xattr -rd com.apple.quarantine $app 2>/dev/null || true; /usr/bin/codesign --force --deep --sign - $app >/dev/null; fi";
        }
      ];
    };

    system.activationScripts.bifrostGaugeRuntimeDirs.text = ''
      install -d -m 0755 -o ${user} -g staff ${lib.escapeShellArg cfg.logDir}
    '';

    launchd.user.agents.bifrost-gauge-bifrost = lib.mkIf cfg.startBifrostAtLogin {
      serviceConfig = {
        Label = label;
        ProgramArguments = [
          "${bifrostHost}/bin/bifrost-gauge-bifrost-host"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        WorkingDirectory = "${cfg.repoRoot}/bifrost";
        StandardOutPath = "${cfg.logDir}/bifrost-host-launchd.out.log";
        StandardErrorPath = "${cfg.logDir}/bifrost-host-launchd.err.log";
      };
    };
  };
}
