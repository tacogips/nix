{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.ghostty;
in
{
  options.taco.darwin.apps.ghostty.enable =
    lib.mkEnableOption "Ghostty terminal installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "ghostty" ];
    };
  };
}
