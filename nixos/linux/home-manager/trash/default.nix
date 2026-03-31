{
  lib,
  pkgs,
  ...
}:

let
  trashPrune = pkgs.writeShellApplication {
    name = "trash-prune";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
    ];
    text = ''
      set -euo pipefail

      trashBase="''${XDG_DATA_HOME:-$HOME/.local/share}/Trash"
      infoDir="$trashBase/info"
      filesDir="$trashBase/files"

      if [[ ! -d "$infoDir" || ! -d "$filesDir" ]]; then
        exit 0
      fi

      find "$infoDir" -type f -name '*.trashinfo' -print | while IFS= read -r infoPath; do
        entryName="$(basename "$infoPath" .trashinfo)"
        rm -rf -- "$filesDir/$entryName"
        rm -f -- "$infoPath"
      done

      rm -f -- "$trashBase/directorysizes"
    '';
  };
in
{
  systemd.user.services.trash-prune = {
    Unit = {
      Description = "Empty trash contents";
    };

    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe trashPrune;
    };
  };

  systemd.user.timers.trash-prune = {
    Unit = {
      Description = "Run trash cleanup every 15 minutes";
    };

    Timer = {
      OnBootSec = "15m";
      OnUnitActiveSec = "15m";
      Unit = "trash-prune.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
