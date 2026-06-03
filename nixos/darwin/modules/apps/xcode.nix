{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.xcode;
in
{
  options.taco.darwin.apps.xcode.enable = lib.mkEnableOption "Xcode installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps.Xcode = 497799835;
  };
}
