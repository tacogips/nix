{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.apple-developer;
in
{
  options.taco.darwin.apps.apple-developer.enable =
    lib.mkEnableOption "Apple Developer installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps."Apple Developer" = 640199958;
  };
}
