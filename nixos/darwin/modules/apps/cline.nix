{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.cline;
in
{
  options.taco.darwin.apps.cline.enable = lib.mkEnableOption "Cline client installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      brews = [ "cline" ];
    };
  };
}
