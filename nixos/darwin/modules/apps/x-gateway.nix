{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.x-gateway;
in
{
  options.taco.darwin.apps.x-gateway.enable =
    lib.mkEnableOption "x-gateway CLIs installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [
        "tacogips/tap/x-gateway-reader"
        "tacogips/tap/x-gateway-writer"
      ];
    };
  };
}
