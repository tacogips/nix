{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.rielflow;
in
{
  options.taco.darwin.apps.rielflow.enable =
    lib.mkEnableOption "Rielflow CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    taco.darwin.homebrew.taps = [ "tacogips/tap" ];

    homebrew = {
      enable = true;
      brews = [ "tacogips/tap/rielflow" ];
    };
  };
}
