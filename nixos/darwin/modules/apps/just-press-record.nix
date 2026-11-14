{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.just-press-record;
in
{
  options.taco.darwin.apps.just-press-record.enable =
    lib.mkEnableOption "Just Press Record installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps."Just Press Record" = 1033342465;
  };
}
