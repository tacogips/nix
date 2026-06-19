{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.riela;
in
{
  options.taco.darwin.apps.riela.enable = lib.mkEnableOption "Riela CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];
    taco.darwin.homebrew.trustedTaps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [ "tacogips/tap/riela" ];
    };
  };
}
