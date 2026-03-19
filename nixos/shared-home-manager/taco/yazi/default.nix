{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.taco.yazi;
  helixPaneOpener = pkgs.writeShellApplication {
    name = "hx-pane-open";
    text = ''
      set -euo pipefail

      file_path="''${1:-}"

      if [[ -z "$file_path" ]]; then
        exit 0
      fi

      helix_escape() {
        local escaped

        escaped="$1"
        escaped="''${escaped//\\/\\\\}"
        escaped="''${escaped//\"/\\\"}"
        printf '%s' "$escaped"
      }

      shell_escape() {
        printf '%q' "$1"
      }

      tmux_pane_is_helix() {
        [[ "$1" == "hx" || "$1" == "helix" ]]
      }

      open_in_tmux_directory() {
        local target_dir target_pane pane_command shell_path

        target_dir="$1"
        target_pane="$2"
        pane_command="$3"
        shell_path="''${SHELL:-${pkgs.fish}/bin/fish}"

        if tmux_pane_is_helix "$pane_command"; then
          ${pkgs.tmux}/bin/tmux respawn-pane -k -t "$target_pane" -c "$target_dir" "$shell_path -l"
          return
        fi

        ${pkgs.tmux}/bin/tmux send-keys -t "$target_pane" C-c
        ${pkgs.tmux}/bin/tmux send-keys -t "$target_pane" "cd -- $(shell_escape "$target_dir")"
        ${pkgs.tmux}/bin/tmux send-keys -t "$target_pane" Enter
      }

      open_in_tmux_file() {
        local target_file pane_command escaped_path

        target_file="$1"
        pane_command="$2"
        escaped_path="$(helix_escape "$target_file")"

        if tmux_pane_is_helix "$pane_command"; then
          ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" Escape
          ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" ":open \"$escaped_path\""
          ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" Enter
          return
        fi

        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" C-c
        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" "${pkgs.helix}/bin/hx -- $(shell_escape "$target_file")"
        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" Enter
      }

      mime_info="$(${pkgs.file}/bin/file -bL --mime -- "$file_path" 2>/dev/null || true)"

      if [[ "$mime_info" == *"charset=binary"* ]]; then
        exec ${cfg.openCommand} "$file_path"
      fi

      if [[ "''${TACO_IDE_LAYOUT:-0}" != "1" ]]; then
        exec ${pkgs.helix}/bin/hx "$file_path"
      fi

      if [[ -n "''${ZELLIJ:-}" ]]; then
        escaped_path="$(helix_escape "$file_path")"

        if ! ${pkgs.zellij}/bin/zellij action move-focus right >/dev/null 2>&1; then
          exec ${pkgs.helix}/bin/hx "$file_path"
        fi

        ${pkgs.zellij}/bin/zellij action write 27
        ${pkgs.zellij}/bin/zellij action write-chars ":open \"$escaped_path\""
        ${pkgs.zellij}/bin/zellij action write 13
        ${pkgs.zellij}/bin/zellij action move-focus left >/dev/null 2>&1 || true
        exit 0
      fi

      if [[ -n "''${TMUX:-}" && -n "''${TACO_TMUX_EDITOR_PANE:-}" ]]; then
        pane_command="$(${pkgs.tmux}/bin/tmux display-message -p -t "$TACO_TMUX_EDITOR_PANE" '#{pane_current_command}' 2>/dev/null || true)"

        if [[ -z "$pane_command" ]]; then
          exec ${pkgs.helix}/bin/hx "$file_path"
        fi

        if [[ -d "$file_path" ]]; then
          target_pane="''${TACO_TMUX_DIRECTORY_PANE:-$TACO_TMUX_EDITOR_PANE}"
          target_pane_command="$(${pkgs.tmux}/bin/tmux display-message -p -t "$target_pane" '#{pane_current_command}' 2>/dev/null || true)"

          if [[ -z "$target_pane_command" ]]; then
            target_pane="$TACO_TMUX_EDITOR_PANE"
            target_pane_command="$pane_command"
          fi

          open_in_tmux_directory "$file_path" "$target_pane" "$target_pane_command"
          exit 0
        fi

        open_in_tmux_file "$file_path" "$pane_command"
        exit 0
      fi

      exec ${pkgs.helix}/bin/hx "$file_path"
    '';
  };
  directoryTerminalOpener = pkgs.writeShellApplication {
    name = "yazi-open-terminal";
    text =
      if pkgs.stdenv.hostPlatform.isDarwin then
        ''
          set -euo pipefail

          for target_path in "$@"; do
            if [[ -d "$target_path" ]]; then
              if [[ -n "''${TMUX:-}" && -n "''${TACO_TMUX_DIRECTORY_PANE:-}" ]]; then
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" C-c
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" "cd -- $(printf '%q' "$target_path")"
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" Enter
                continue
              fi

              /usr/bin/open -na Ghostty.app --args --working-directory="$target_path"
            fi
          done
        ''
      else
        ''
          set -euo pipefail

          for target_path in "$@"; do
            if [[ -d "$target_path" ]]; then
              if [[ -n "''${TMUX:-}" && -n "''${TACO_TMUX_DIRECTORY_PANE:-}" ]]; then
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" C-c
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" "cd -- $(printf '%q' "$target_path")"
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" Enter
                continue
              fi

              ${pkgs.ghostty}/bin/ghostty --working-directory="$target_path" >/dev/null 2>&1 &
            fi
          done
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

        open.prepend_rules = [
          {
            mime = "inode/directory";
            use = "open-terminal";
          }
        ];

        opener = {
          edit = [
            {
              run = ''${helixPaneOpener}/bin/hx-pane-open "$@"'';
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

          open-terminal = [
            {
              run = ''${directoryTerminalOpener}/bin/yazi-open-terminal "$@"'';
              orphan = true;
              desc = "Open terminal here";
            }
          ];
        };
      };
    };
  };
}
