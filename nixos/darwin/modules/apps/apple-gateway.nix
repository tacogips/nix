{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.apple-gateway;
in
{
  options.taco.darwin.apps.apple-gateway.enable =
    lib.mkEnableOption "apple-gateway CLIs installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [ "tacogips/tap/apple-gateway" ];
    };
  };
}
