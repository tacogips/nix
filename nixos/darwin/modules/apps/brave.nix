{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.brave;
in
{
  options.taco.darwin.apps.brave.enable = lib.mkEnableOption "Brave Browser installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "brave-browser" ];
    };
  };
}
