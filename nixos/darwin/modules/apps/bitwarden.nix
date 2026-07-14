{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.bitwarden;
in
{
  options.taco.darwin.apps.bitwarden.enable =
    lib.mkEnableOption "Bitwarden and the Secrets Manager CLI";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tonyxiao/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tonyxiao/tap" ];

    homebrew = {
      enable = true;
      brews = [ "tonyxiao/tap/bws" ];
      masApps.Bitwarden = 1352778147;
    };
  };
}
