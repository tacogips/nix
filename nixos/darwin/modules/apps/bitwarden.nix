{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.bitwarden;
in
{
  options.taco.darwin.apps.bitwarden.enable =
    lib.mkEnableOption "Bitwarden installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps.Bitwarden = 1352778147;
  };
}
