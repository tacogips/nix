{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.claude;
in
{
  options.taco.darwin.apps.claude.enable =
    lib.mkEnableOption "Claude Desktop app installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "claude" ];
    };
  };
}
