{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.cursor;
in
{
  options.taco.darwin.apps.cursor.enable =
    lib.mkEnableOption "Cursor app and CLI installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [
        "cursor"
        "cursor-cli"
      ];
    };
  };
}
