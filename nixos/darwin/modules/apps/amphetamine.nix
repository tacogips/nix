{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.amphetamine;
in
{
  options.taco.darwin.apps.amphetamine.enable =
    lib.mkEnableOption "Amphetamine installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps.Amphetamine = 937984704;
  };
}
