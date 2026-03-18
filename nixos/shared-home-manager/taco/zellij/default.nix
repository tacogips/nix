{ pkgs, ... }:

let
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    fzf
    git
    zellij
  ];

  ideYaziScript = pkgs.writeShellApplication {
    name = "ide-yazi";
    text = ''
      set -euo pipefail
      export TACO_IDE_LAYOUT=1
      exec ${pkgs.yazi}/bin/yazi
    '';
  };

  projectSelection = ''
    projects_root="''${IDE_PROJECTS_ROOT:-$HOME/projects}"

    selected="$(
      find "$projects_root" -maxdepth 3 -name .git -type d -printf '%h\n' 2>/dev/null \
        | sort -u \
        | fzf --prompt="Project > "
    )"

    if [[ -z "$selected" ]]; then
      echo "No project selected"
      exit 0
    fi

    project_name="$(basename "$selected")"
    branch="$(cd "$selected" && git branch --show-current 2>/dev/null || echo "main")"
  '';

  ideScript = pkgs.writeShellApplication {
    name = "ide";
    inherit runtimeInputs;
    text = ''
      set -euo pipefail
      ${projectSelection}

      session_name="''${project_name}:''${branch//\//-}"

      # Zellij limits session names on macOS, so keep it short and portable.
      session_name="''${session_name:0:30}"

      if [[ -n "''${ZELLIJ:-}" ]]; then
        zellij action detach
      fi

      cd "$selected"
      exec zellij attach "$session_name" 2>/dev/null || exec zellij -s "$session_name"
    '';
  };

  ideAgentScript = pkgs.writeShellApplication {
    name = "ide-agent";
    inherit runtimeInputs;
    text = ''
      set -euo pipefail

      columns="''${1:-3}"

      case "$columns" in
        3|4|5)
          ;;
        *)
          echo "Usage: ide-agent [3|4|5]" >&2
          exit 1
          ;;
      esac

      ${projectSelection}

      layout="agents-''${columns}col"
      session_name="''${project_name}:''${branch//\//-}:a''${columns}"
      session_name="''${session_name:0:30}"

      if [[ -n "''${ZELLIJ:-}" ]]; then
        zellij action detach
      fi

      cd "$selected"
      exec zellij attach "$session_name" 2>/dev/null || exec zellij -s "$session_name" -l "$layout"
    '';
  };
in
{
  home.packages = [
    ideScript
    ideAgentScript
  ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = false;

    settings = {
      default_layout = "ide";
      pane_frames = false;
      simplified_ui = true;
    };

    layouts.ide = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="tab-bar"
              }
              children
              pane size=2 borderless=true {
                  plugin location="status-bar"
              }
          }
          tab name="ide" focus=true {
              pane split_direction="horizontal" {
                  pane size="35%" focus=true name="Yazi" {
                      command "${ideYaziScript}/bin/ide-yazi"
                  }
                  pane name="Helix" {
                      command "${pkgs.helix}/bin/hx"
                  }
              }
          }
      }
    '';

    layouts.agents-3col = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="tab-bar"
              }
              children
              pane size=2 borderless=true {
                  plugin location="status-bar"
              }
          }
          tab name="agents-3" focus=true {
              pane split_direction="horizontal" {
                  pane focus=true name="Agent 1"
                  pane name="Agent 2"
                  pane name="Agent 3"
              }
          }
      }
    '';

    layouts.agents-4col = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="tab-bar"
              }
              children
              pane size=2 borderless=true {
                  plugin location="status-bar"
              }
          }
          tab name="agents-4" focus=true {
              pane split_direction="horizontal" {
                  pane focus=true name="Agent 1"
                  pane name="Agent 2"
                  pane name="Agent 3"
                  pane name="Agent 4"
              }
          }
      }
    '';

    layouts.agents-5col = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="tab-bar"
              }
              children
              pane size=2 borderless=true {
                  plugin location="status-bar"
              }
          }
          tab name="agents-5" focus=true {
              pane split_direction="horizontal" {
                  pane focus=true name="Agent 1"
                  pane name="Agent 2"
                  pane name="Agent 3"
                  pane name="Agent 4"
                  pane name="Agent 5"
              }
          }
      }
    '';

    extraConfig = ''
      keybinds {
          shared_except "locked" {
              bind "Ctrl Shift h" { MoveFocusOrTab "Left"; }
              bind "Ctrl Shift j" { MoveFocusOrTab "Down"; }
              bind "Ctrl Shift k" { MoveFocusOrTab "Up"; }
              bind "Ctrl Shift l" { MoveFocusOrTab "Right"; }

              bind "Ctrl Shift 1" { GoToTab 1; }
              bind "Ctrl Shift 2" { GoToTab 2; }
              bind "Ctrl Shift 3" { GoToTab 3; }
              bind "Ctrl Shift 4" { GoToTab 4; }
              bind "Ctrl Shift 5" { GoToTab 5; }
              bind "Ctrl Shift 6" { GoToTab 6; }
              bind "Ctrl Shift 7" { GoToTab 7; }
              bind "Ctrl Shift 8" { GoToTab 8; }
              bind "Ctrl Shift 9" { GoToTab 9; }
              bind "Ctrl Shift 0" { GoToTab 10; }
          }
      }
    '';
  };
}
