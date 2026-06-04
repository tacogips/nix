{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.kindle;
in
{
  options.taco.darwin.apps.kindle.enable =
    lib.mkEnableOption "Amazon Kindle installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps."Amazon Kindle" = 302584613;
  };
}
