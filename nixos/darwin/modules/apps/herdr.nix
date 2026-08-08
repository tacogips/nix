{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.herdr;
in
{
  options.taco.darwin.apps.herdr.enable = lib.mkEnableOption "Herdr installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      brews = [ "herdr" ];
    };
  };
}
