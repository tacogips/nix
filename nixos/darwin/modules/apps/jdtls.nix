{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.jdtls;
in
{
  options.taco.darwin.apps.jdtls.enable =
    lib.mkEnableOption "Eclipse JDT language server installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      brews = [ "jdtls" ];
    };
  };
}
