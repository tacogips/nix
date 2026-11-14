{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.ccusage-gauge;
in
{
  options.taco.darwin.apps.ccusage-gauge.enable =
    lib.mkEnableOption "CCUsage Gauge installed with Homebrew Cask";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      casks = [ "tacogips/tap/ccusage-gauge" ];
    };
  };
}
