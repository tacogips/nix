{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.taco.yazi;
  helixPaneOpener = pkgs.writeShellApplication {
    name = "hx-zellij-open";
    text = ''
      set -euo pipefail

      file_path="''${1:-}"

      if [[ -z "$file_path" ]]; then
        exit 0
      fi

      if [[ "''${TACO_IDE_LAYOUT:-0}" != "1" || -z "''${ZELLIJ:-}" ]]; then
        exec ${pkgs.helix}/bin/hx "$file_path"
      fi

      escaped_path="$file_path"
      escaped_path="''${escaped_path//\\/\\\\}"
      escaped_path="''${escaped_path//\"/\\\"}"

      if ! ${pkgs.zellij}/bin/zellij action move-focus right >/dev/null 2>&1; then
        exec ${pkgs.helix}/bin/hx "$file_path"
      fi

      ${pkgs.zellij}/bin/zellij action write 27
      ${pkgs.zellij}/bin/zellij action write-chars ":open \"$escaped_path\""
      ${pkgs.zellij}/bin/zellij action write 13
      ${pkgs.zellij}/bin/zellij action move-focus left >/dev/null 2>&1 || true
    '';
  };
  keymap = import ./keymap.nix;
in
{
  options.taco.yazi.openCommand = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "${pkgs.xdg-utils}/bin/xdg-open";
    description = ''
      Absolute command Yazi should use when it opens files outside the terminal.
      Set this in a platform-specific Home Manager module so Linux and Darwin can
      use different launchers.
    '';
  };

  config = {
    assertions = [
      {
        assertion = cfg.openCommand != null;
        message = "Set taco.yazi.openCommand in a platform-specific Home Manager module.";
      }
    ];

    programs.yazi = {
      enable = true;
      enableFishIntegration = false;
      shellWrapperName = "y";
      extraPackages = with pkgs; [
        fd
        file
        fzf
        jq
        ripgrep
        zoxide
      ];

      inherit keymap;

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "mtime";
          sort_dir_first = true;
          sort_reverse = true;
        };

        opener = {
          edit = [
            {
              run = ''${helixPaneOpener}/bin/hx-zellij-open "$@"'';
              block = true;
              desc = "Helix";
            }
          ];

          open = [
            {
              run = ''${cfg.openCommand} "$@"'';
              orphan = true;
              desc = "Open";
            }
          ];
        };
      };
    };
  };
}
