{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.riela;
in
{
  options.taco.darwin.apps.riela.enable =
    lib.mkEnableOption "Riela CLI and RielaApp installed with Homebrew Cask";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      casks = [ "tacogips/tap/riela" ];
    };

    system.activationScripts.preActivation.text = ''
      # Riela 0.1.5 split CLI-only formula delivery from the cask that ships
      # RielaApp.app. Remove the old formula first so the cask can link `riela`.
      for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew" ] && "$brew" list --formula riela >/dev/null 2>&1; then
          "$brew" uninstall --formula riela || true
        fi
      done
    '';
  };
}
