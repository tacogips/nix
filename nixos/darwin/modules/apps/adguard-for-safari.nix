{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.adguard-for-safari;
in
{
  options.taco.darwin.apps.adguard-for-safari.enable =
    lib.mkEnableOption "AdGuard for Safari installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps."AdGuard for Safari" = 1440147259;
  };
}
