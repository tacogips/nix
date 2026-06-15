{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.bifrost-gage;
in
{
  options.taco.darwin.apps.bifrost-gage.enable =
    lib.mkEnableOption "Bifrost Gage installed with Homebrew Cask";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      casks = [ "tacogips/tap/bifrost-gage" ];
    };
  };
}
