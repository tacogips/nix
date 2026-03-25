{
  pkgs,
  lib,
  ...
}:

let
  cursorCliPackage =
    if pkgs.stdenv.isLinux then
      pkgs.symlinkJoin {
        name = "cursor-cli-wrapped";
        paths = [ pkgs.cursor-cli ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm "$out/bin/cursor-agent"
          cat > "$out/bin/cursor-agent" <<'EOF'
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          real_cursor_agent="${lib.getExe pkgs.cursor-cli}"

          subcommand=""
          for arg in "$@"; do
            case "$arg" in
              -*) ;;
              *) subcommand="$arg"; break ;;
            esac
          done

          should_force=1
          case "''${subcommand:-agent}" in
            about|help|login|logout|models|status|whoami|update|install-shell-integration|uninstall-shell-integration|mcp|generate-rule|rule|sandbox)
              should_force=0
              ;;
          esac

          if [ "$should_force" -eq 1 ]; then
            cursor_config_dir="''${CURSOR_CONFIG_DIR:-$HOME/.cursor}"

            trust_workspace() {
              local workspace_path="$1"
              local workspace_slug=""
              local trust_dir=""
              local trust_file=""

              if [ -z "$workspace_path" ]; then
                return 0
              fi

              workspace_path="$(${pkgs.coreutils}/bin/realpath -m "$workspace_path")"
              if [ "$workspace_path" = "$HOME" ] || [ "$workspace_path" = "/" ]; then
                return 0
              fi

              workspace_slug="$(
                printf '%s' "$workspace_path" \
                  | ${pkgs.coreutils}/bin/tr '[:upper:]' '[:lower:]' \
                  | ${pkgs.gnused}/bin/sed \
                    -e 's#^/*##' \
                    -e 's#[/[:space:]]#-#g' \
                    -e 's#[^[:alnum:]._-]#-#g' \
                    -e 's#-\{2,\}#-#g' \
                    -e 's#^-##' \
                    -e 's#-$##'
              )"

              if [ -z "$workspace_slug" ]; then
                return 0
              fi

              trust_dir="$cursor_config_dir/projects/$workspace_slug"
              trust_file="$trust_dir/.workspace-trusted"

              if [ ! -e "$trust_file" ]; then
                ${pkgs.coreutils}/bin/mkdir -p "$trust_dir"
                printf '{\n  "trustedAt": "%s",\n  "workspacePath": "%s",\n  "trustMethod": "nix-wrapper"\n}\n' \
                  "$(${pkgs.coreutils}/bin/date -Iseconds)" \
                  "$workspace_path" \
                  > "$trust_file"
              fi
            }

            trust_workspace "$PWD"

            git_root="$(${pkgs.git}/bin/git rev-parse --show-toplevel 2>/dev/null || true)"
            if [ -n "$git_root" ] && [ "$git_root" != "$PWD" ]; then
              trust_workspace "$git_root"
            fi

            exec "$real_cursor_agent" --yolo --approve-mcps "$@"
          fi

          exec "$real_cursor_agent" "$@"
          EOF
          chmod +x "$out/bin/cursor-agent"
        '';
      }
    else if pkgs.stdenv.isDarwin then
      pkgs.cursor-cli
    else
      null;
in
{
  home.file.".cursor/cli-config.json".text =
    builtins.toJSON {
      version = 1;
      editor = {
        vimMode = true;
      };
    }
    + "\n";

  home.packages = lib.optional (cursorCliPackage != null) cursorCliPackage;
}
