{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.ccusage;
in
{
  options.taco.darwin.apps.ccusage.enable = lib.mkEnableOption "ccusage CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      brews = [ "ccusage" ];
    };
  };
}
