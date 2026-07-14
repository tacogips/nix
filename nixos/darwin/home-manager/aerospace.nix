{
  config,
  pkgs,
  lib,
  ...
}:

let
  aerospaceDisplaySync = pkgs.writeShellScript "aerospace-display-sync" ''
    set -eu

    AEROSPACE="${pkgs.aerospace}/bin/aerospace"
    GREP="${pkgs.gnugrep}/bin/grep"
    MKDIR="${pkgs.coreutils}/bin/mkdir"
    CAT="${pkgs.coreutils}/bin/cat"
    SORT="${pkgs.coreutils}/bin/sort"
    TIMEOUT="${pkgs.coreutils}/bin/timeout"

    state_dir="$HOME/.local/state/aerospace"
    state_file="$state_dir/monitor-topology"
    state_version="external-workspace-assignment-v6"

    run_aerospace() {
      "$TIMEOUT" 5 "$AEROSPACE" "$@"
    }

    "$MKDIR" -p "$state_dir"

    if ! monitor_lines="$(run_aerospace list-monitors --format '%{monitor-id}|%{monitor-name}' 2>/dev/null)"; then
      exit 0
    fi
    current_state="$(printf '%s\n%s\n' "$state_version" "$monitor_lines" | "$SORT")"

    if ! workspace_lines="$(run_aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}' 2>/dev/null)"; then
      exit 0
    fi

    invalid_workspaces=""
    while IFS='|' read -r workspace monitor_id; do
      case "$workspace" in
        [1-9]) ;;
        *) invalid_workspaces="$invalid_workspaces $workspace" ;;
      esac
    done <<< "$workspace_lines"

    external_ids=""
    built_in_id=""
    while IFS='|' read -r monitor_id monitor_name; do
      if [ -z "$monitor_id" ]; then
        continue
      fi

      if printf '%s\n' "$monitor_name" | "$GREP" -qi 'built-in'; then
        built_in_id="$monitor_id"
      else
        external_ids="$external_ids $monitor_id"
      fi
    done <<< "$monitor_lines"

    external_count=0
    external_one=""
    external_two=""
    for external_id in $external_ids; do
      external_count=$((external_count + 1))
      if [ "$external_count" -eq 1 ]; then
        external_one="$external_id"
      elif [ "$external_count" -eq 2 ]; then
        external_two="$external_id"
      fi
      # Additional external monitors are intentionally left without dedicated
      # persistent workspaces so external workspaces stay fixed to 1 and 2.
    done

    if [ "$external_count" -lt 1 ]; then
      if [ -z "$built_in_id" ]; then
        exit 0
      fi
    fi

    workspace_is_on_monitor() {
      wanted_workspace="$1"
      wanted_monitor="$2"

      while IFS='|' read -r listed_workspace listed_monitor; do
        if [ "$listed_workspace" = "$wanted_workspace" ]; then
          [ "$listed_monitor" = "$wanted_monitor" ] && return 0
          return 1
        fi
      done <<< "$workspace_lines"

      return 1
    }

    assignment_mismatch=""
    if [ -n "$built_in_id" ] && ! workspace_is_on_monitor "9" "$built_in_id"; then
      assignment_mismatch="1"
    fi
    if [ -n "$external_one" ] && ! workspace_is_on_monitor "1" "$external_one"; then
      assignment_mismatch="1"
    fi
    if [ -n "$external_two" ]; then
      if ! workspace_is_on_monitor "2" "$external_two"; then
        assignment_mismatch="1"
      fi
    elif [ -n "$external_one" ] && ! workspace_is_on_monitor "2" "$external_one"; then
      assignment_mismatch="1"
    fi

    force="''${1:-}"
    previous_state=""
    if [ -f "$state_file" ]; then
      previous_state="$("$CAT" "$state_file")"
    fi

    if [ "$force" != "--force" ] && [ "$current_state" = "$previous_state" ] && [ -z "$invalid_workspaces" ] && [ -z "$assignment_mismatch" ]; then
      exit 0
    fi

    # AeroSpace creates fallback workspaces when displays are attached. Move
    # windows out of multi-digit or non-numeric fallbacks before selecting the
    # stable one-digit workspace assigned to each display.
    if [ -n "$invalid_workspaces" ]; then
      if ! window_lines="$(run_aerospace list-windows --all --format '%{window-id}|%{workspace}|%{monitor-id}' 2>/dev/null)"; then
        exit 0
      fi

      while IFS='|' read -r window_id workspace monitor_id; do
        case "$workspace" in
          [1-9]) continue ;;
        esac

        target_workspace=""
        if [ -n "$built_in_id" ] && [ "$monitor_id" = "$built_in_id" ]; then
          target_workspace="9"
        elif [ -n "$external_one" ] && [ "$monitor_id" = "$external_one" ]; then
          target_workspace="1"
        elif [ -n "$external_two" ] && [ "$monitor_id" = "$external_two" ]; then
          target_workspace="2"
        fi

        if [ -n "$window_id" ] && [ -n "$target_workspace" ]; then
          run_aerospace move-node-to-workspace --window-id "$window_id" "$target_workspace"
        fi
      done <<< "$window_lines"
    fi

    if [ -n "$built_in_id" ]; then
      run_aerospace move-workspace-to-monitor --workspace 9 "$built_in_id"
      run_aerospace workspace 9
    fi

    if [ -n "$external_one" ]; then
      run_aerospace move-workspace-to-monitor --workspace 1 "$external_one"
      if [ -n "$external_two" ]; then
        run_aerospace move-workspace-to-monitor --workspace 2 "$external_two"
      else
        run_aerospace move-workspace-to-monitor --workspace 2 "$external_one"
      fi
      run_aerospace workspace 1
    fi
    if [ "$external_count" -ge 2 ]; then
      run_aerospace workspace 2
    fi

    printf '%s\n' "$current_state" > "$state_file"
  '';
in
{
  # Override the aerospace reload activation to handle when AeroSpace isn't running
  home.activation.aerospace-reload-config = lib.mkForce (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Only reload if AeroSpace is running and responding to CLI commands.
      if ${pkgs.coreutils}/bin/timeout 5 ${pkgs.aerospace}/bin/aerospace list-monitors --count >/dev/null 2>&1; then
        $DRY_RUN_CMD ${pkgs.aerospace}/bin/aerospace reload-config || echo "AeroSpace reload failed, continuing..."
        $DRY_RUN_CMD ${aerospaceDisplaySync} --force || echo "AeroSpace display sync failed, continuing..."
      else
        echo "AeroSpace not running, skipping reload"
      fi
    ''
  );

  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      config-version = 2;

      # Start AeroSpace automatically at login
      start-at-login = true;

      # Commands to run after AeroSpace startup
      after-startup-command = [
        "layout tiles"
        "exec-and-forget ${aerospaceDisplaySync} --force"
      ];

      # The sync agent assigns workspaces 1 and 2 to external monitor IDs
      # after topology changes. Keep only workspace 9 force-pinned here so
      # dynamic external assignment is not blocked by AeroSpace.
      persistent-workspaces = [
        "1"
        "2"
        "9"
      ];

      "workspace-to-monitor-force-assignment" = {
        "3" = [
          "secondary"
          "main"
        ];
        "4" = [
          "secondary"
          "main"
        ];
        "5" = [
          "secondary"
          "main"
        ];
        "6" = [
          "secondary"
          "main"
        ];
        "7" = [
          "secondary"
          "main"
        ];
        "8" = [
          "secondary"
          "main"
        ];
        "9" = [
          "built-in"
          "main"
        ];
      };

      # Normalization settings
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Container settings
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "horizontal";

      # Gaps configuration
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };

      # Key mapping preset
      key-mapping.preset = "qwerty";

      # Mode configuration
      mode.main.binding = {
        # Focus management
        "alt-shift-h" = "focus left";
        "alt-shift-j" = "focus down";
        "alt-shift-k" = "focus up";
        "alt-shift-l" = "focus right";

        # Move windows
        "ctrl-shift-h" = "move left";
        "ctrl-shift-j" = "move down";
        "ctrl-shift-k" = "move up";
        "ctrl-shift-l" = "move right";

        # Resize windows
        "alt-shift-minus" = "resize smart -50";
        "alt-shift-equal" = "resize smart +50";

        # Workspace navigation
        "alt-shift-1" = "workspace 1";
        "alt-shift-2" = "workspace 2";
        "alt-shift-3" = "workspace 3";
        "alt-shift-4" = "workspace 4";
        "alt-shift-5" = "workspace 5";
        "alt-shift-6" = "workspace 6";
        "alt-shift-7" = "workspace 7";
        "alt-shift-8" = "workspace 8";
        "alt-shift-9" = "workspace 9";

        # Move window to workspace
        "alt-ctrl-1" = "move-node-to-workspace 1";
        "alt-ctrl-2" = "move-node-to-workspace 2";
        "alt-ctrl-3" = "move-node-to-workspace 3";
        "alt-ctrl-4" = "move-node-to-workspace 4";
        "alt-ctrl-5" = "move-node-to-workspace 5";
        "alt-ctrl-6" = "move-node-to-workspace 6";
        "alt-ctrl-7" = "move-node-to-workspace 7";
        "alt-ctrl-8" = "move-node-to-workspace 8";
        "alt-ctrl-9" = "move-node-to-workspace 9";

        # Layout management
        "alt-shift-space" = "layout floating tiling";
        "alt-shift-f" = "fullscreen";

        # Join orientation
        "alt-shift-s" = "join-with down";
        "alt-shift-v" = "join-with right";

        # Launch applications
        "alt-shift-enter" = "exec-and-forget /usr/bin/open -na Ghostty.app";

        # Service mode
        "alt-shift-semicolon" = "mode service";
      };

      # Service mode for advanced operations
      mode.service.binding = {
        "esc" = [
          "reload-config"
          "exec-and-forget ${aerospaceDisplaySync} --force"
          "mode main"
        ];
        "r" = [
          "flatten-workspace-tree"
          "mode main"
        ];
        "f" = [
          "layout floating tiling"
          "mode main"
        ];
        "backspace" = [
          "close-all-windows-but-current"
          "mode main"
        ];

        # Move between monitors
        "h" = [
          "join-with left"
          "mode main"
        ];
        "j" = [
          "join-with down"
          "mode main"
        ];
        "k" = [
          "join-with up"
          "mode main"
        ];
        "l" = [
          "join-with right"
          "mode main"
        ];
      };

      # Application-specific window rules
      on-window-detected = [
        {
          "if" = {
            app-id = "com.google.Chrome";
          };
          run = "move-node-to-workspace 1";
        }
        {
          "if" = {
            app-id = "com.apple.finder";
          };
          run = "move-node-to-workspace 2";
        }
        {
          "if" = {
            app-id = "com.microsoft.VSCode";
          };
          run = "move-node-to-workspace 3";
        }
        {
          "if" = {
            app-id = "com.tinyspeck.slackmacgap";
          };
          run = "move-node-to-workspace 9";
        }
        {
          "if" = {
            app-id = "md.obsidian";
          };
          run = "move-node-to-workspace 8";
        }
      ];

      # Mouse follows focus
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
    };
  };

  launchd.agents.aerospace-display-sync = {
    enable = true;
    config = {
      Label = "org.hm.aerospace-display-sync";
      ProgramArguments = [ "${aerospaceDisplaySync}" ];
      RunAtLoad = true;
      StartInterval = 5;
      StandardOutPath = "/tmp/aerospace-display-sync.log";
      StandardErrorPath = "/tmp/aerospace-display-sync.log";
    };
  };
}
