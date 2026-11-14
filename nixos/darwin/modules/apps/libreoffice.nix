{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.libreoffice;
in
{
  options.taco.darwin.apps.libreoffice.enable =
    lib.mkEnableOption "LibreOffice installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "libreoffice" ];
    };
  };
}
