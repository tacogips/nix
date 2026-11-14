{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.peekaboo;
in
{
  options.taco.darwin.apps.peekaboo.enable =
    lib.mkEnableOption "Peekaboo CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "steipete/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "steipete/tap" ];

    homebrew = {
      enable = true;
      brews = [ "steipete/tap/peekaboo" ];
    };
  };
}
