{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.claude-code;
in
{
  options.taco.darwin.apps.claude-code.enable =
    lib.mkEnableOption "Claude Code installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "claude-code" ];
    };
  };
}
