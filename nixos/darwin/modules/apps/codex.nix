{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.codex;
in
{
  options.taco.darwin.apps.codex.enable =
    lib.mkEnableOption "OpenAI Codex desktop app installed with Homebrew";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [
        "codex-app"
      ];
    };
  };
}
