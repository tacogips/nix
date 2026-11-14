{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.mail-gateway;
in
{
  options.taco.darwin.apps.mail-gateway.enable =
    lib.mkEnableOption "mail-gateway CLIs installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [
        "tacogips/tap/mail-gateway-draft"
        "tacogips/tap/mail-gateway-reader"
        "tacogips/tap/mail-gateway-sender"
      ];
    };
  };
}
