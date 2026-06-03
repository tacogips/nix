{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.ign;
in
{
  options.taco.darwin.apps.ign.enable = lib.mkEnableOption "ign CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [ "tacogips/tap/ign" ];
    };
  };
}
