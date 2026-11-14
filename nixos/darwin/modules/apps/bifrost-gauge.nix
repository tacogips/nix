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
        # Before darwin-rebuild, add Bifrost/Claude secrets to kinko shared scope
        # because this LaunchAgent only exports shared keys.
        #
        # For Bifrost's upstream Anthropic provider, the reliable credential is:
        #   kinko set-key --shared ANTHROPIC_API_KEY --value '<sk-ant-api03-...>'
        #
        # ANTHROPIC_API_KEY is an Anthropic Console API key. Create it from the
        # Anthropic Console API Keys page.
        #
        # This wrapper also accepts Claude Code's setup-token as a fallback:
        #   claude setup-token
        #   kinko set-key --shared CLAUDE_CODE_OAUTH_TOKEN --value '<token>'
        #
        # CLAUDE_CODE_OAUTH_TOKEN is the long-lived OAuth token printed by
        # `claude setup-token`. If only the OAuth token is present, this wrapper
        # maps it to ANTHROPIC_API_KEY for Bifrost's current
        # `env.ANTHROPIC_API_KEY` provider config. If Bifrost logs
        # `invalid x-api-key`, add a real ANTHROPIC_API_KEY instead.
        #
        # For Claude Code clients that call this local Bifrost instance:
        #   kinko set-key --shared BIFROST_VK_PERSONAL --value '<local virtual key>'
        #
        # BIFROST_VK_PERSONAL is not an Anthropic credential; choose/generate it
        # locally and use the same value as Claude Code's ANTHROPIC_AUTH_TOKEN
        # when calling Bifrost.
        eval "$(kinko export bash --shared-only --force --confirm=false)"
      fi

      if [ -z "''${ANTHROPIC_API_KEY:-}" ] && [ -n "''${CLAUDE_CODE_OAUTH_TOKEN:-}" ]; then
        export ANTHROPIC_API_KEY="$CLAUDE_CODE_OAUTH_TOKEN"
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
      default = "/Users/${user}/gits/tacogips/bifrost-gauge";
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
      casks = [ "tacogips/tap/bifrost-gauge" ];
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
