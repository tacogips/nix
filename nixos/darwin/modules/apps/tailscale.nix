{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.tailscale;
in
{
  options.taco.darwin.apps.tailscale.enable =
    lib.mkEnableOption "Tailscale installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps.Tailscale = 1475387142;

    system.activationScripts.preActivation.text = ''
      # Remove the CLI-only Homebrew variant before installing the Mac App
      # Store app so that only one Tailscale variant is active.
      for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew" ] && "$brew" list --formula tailscale >/dev/null 2>&1; then
          "$brew" services stop tailscale >/dev/null 2>&1 || true
          "$brew" uninstall --formula tailscale || true
        fi
      done
    '';
  };
}
