{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.kinko;
in
{
  options.taco.darwin.apps.kinko.enable = lib.mkEnableOption "kinko CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [ "tacogips/tap/kinko" ];
    };
  };
}
