{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.claude-code;
in
{
  options.taco.darwin.apps.claude-code.enable =
    lib.mkEnableOption "the latest Claude Code release installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "claude-code@latest" ];
    };

    system.activationScripts.preActivation.text = ''
      # The stable and latest Claude Code casks conflict. Remove the stable
      # cask before Homebrew Bundle installs the latest release channel.
      for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew" ] && sudo --user=${lib.escapeShellArg config.homebrew.user} --set-home "$brew" list --cask claude-code >/dev/null 2>&1; then
          sudo --user=${lib.escapeShellArg config.homebrew.user} --set-home "$brew" uninstall --cask claude-code
        fi
      done
    '';
  };
}
