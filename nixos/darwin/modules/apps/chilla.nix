{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.chilla;
in
{
  options.taco.darwin.apps.chilla.enable =
    lib.mkEnableOption "Chilla markdown viewer installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      casks = [
        {
          name = "tacogips/tap/chilla";
          # Chilla's private cask currently ships an unsigned, unnotarized app.
          # Keep this workaround scoped to Chilla and run it only after cask
          # install or upgrade.
          postinstall = "app=/Applications/chilla.app; if [ -d $app ]; then /usr/bin/xattr -rd com.apple.quarantine $app 2>/dev/null || true; /usr/bin/codesign --force --deep --sign - $app >/dev/null; fi";
        }
      ];
    };
  };
}
