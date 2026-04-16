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

    state_dir="$HOME/.local/state/aerospace"
    state_file="$state_dir/monitor-topology"

    "$MKDIR" -p "$state_dir"

    if ! current_state="$("$AEROSPACE" list-monitors --format '%{monitor-id}|%{monitor-name}|%{monitor-is-main}' 2>/dev/null | "$SORT")"; then
      exit 0
    fi

    force="''${1:-}"
    previous_state=""
    if [ -f "$state_file" ]; then
      previous_state="$("$CAT" "$state_file")"
    fi

    printf '%s\n' "$current_state" > "$state_file"

    if [ "$force" != "--force" ] && [ "$current_state" = "$previous_state" ]; then
      exit 0
    fi

    monitor_count="$("$AEROSPACE" list-monitors --count 2>/dev/null || printf '0')"
    if [ "$monitor_count" -lt 2 ]; then
      exit 0
    fi

    if ! "$AEROSPACE" list-monitors --format '%{monitor-name}' 2>/dev/null | "$GREP" -qi 'built-in'; then
      exit 0
    fi

    "$AEROSPACE" focus-monitor built-in
    "$AEROSPACE" workspace 9
    "$AEROSPACE" focus-monitor secondary
    "$AEROSPACE" workspace 1
  '';
in
{
  # Override the aerospace reload activation to handle when AeroSpace isn't running
  home.activation.aerospace-reload-config = lib.mkForce (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Only reload if AeroSpace is running
      if ${pkgs.darwin.ps}/bin/ps aux | ${pkgs.gnugrep}/bin/grep -q "[A]eroSpace"; then
        $DRY_RUN_CMD ${pkgs.aerospace}/bin/aerospace reload-config || echo "AeroSpace reload failed, continuing..."
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

      # Prefer the external monitor for primary workspaces when docked,
      # while always keeping the built-in display on workspace 9.
      persistent-workspaces = [ "9" ];

      "workspace-to-monitor-force-assignment" = {
        "1" = [
          "secondary"
          "main"
        ];
        "2" = [
          "secondary"
          "main"
        ];
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
        "10" = [
          "secondary"
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
        "alt-shift-0" = "workspace 10";

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
        "alt-ctrl-0" = "move-node-to-workspace 10";

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
          run = "move-node-to-workspace 10";
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
