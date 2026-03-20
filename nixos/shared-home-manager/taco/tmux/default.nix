{ pkgs, ... }:
let
  tmuxLayoutApply = pkgs.writeShellApplication {
    name = "tmux-layout-apply";
    text = ''
      set -euo pipefail

      layout_name="''${1:-}"
      target_window="''${2:-}"

      if [[ -z "$layout_name" || -z "$target_window" ]]; then
        ${pkgs.tmux}/bin/tmux display-message "Usage: tmux-layout-apply <layout> <target-window>"
        exit 1
      fi

      pane_count="$(${pkgs.tmux}/bin/tmux list-panes -t "$target_window" 2>/dev/null | ${pkgs.coreutils}/bin/wc -l | ${pkgs.coreutils}/bin/tr -d '[:space:]')"
      if [[ -z "$pane_count" ]]; then
        ${pkgs.tmux}/bin/tmux display-message "Layout target not found: $target_window"
        exit 1
      fi

      if [[ "$pane_count" != "1" ]]; then
        ${pkgs.tmux}/bin/tmux display-message "Refusing to overwrite window with $pane_count panes"
        exit 1
      fi

      base_pane="$(${pkgs.tmux}/bin/tmux display-message -p -t "$target_window" '#{pane_id}')"
      cwd="$(${pkgs.tmux}/bin/tmux display-message -p -t "$base_pane" '#{pane_current_path}')"

      shell_escape() {
        printf '%q' "$1"
      }

      run_in_pane() {
        local pane command

        pane="$1"
        shift
        command="$*"

        ${pkgs.tmux}/bin/tmux send-keys -t "$pane" C-c
        ${pkgs.tmux}/bin/tmux send-keys -t "$pane" "$command"
        ${pkgs.tmux}/bin/tmux send-keys -t "$pane" Enter
      }

      launch_ide_yazi() {
        local browser_pane editor_pane directory_pane command

        browser_pane="$1"
        editor_pane="$2"
        directory_pane="$3"
        command="cd -- $(shell_escape "$cwd") && export TACO_IDE_LAYOUT=1 TACO_TMUX_EDITOR_PANE=$(shell_escape "$editor_pane") TACO_TMUX_DIRECTORY_PANE=$(shell_escape "$directory_pane") && exec ${pkgs.yazi}/bin/yazi"
        run_in_pane "$browser_pane" "$command"
      }

      case "$layout_name" in
        ide-3pane)
          center_pane="$(${pkgs.tmux}/bin/tmux split-window -h -P -F '#{pane_id}' -t "$base_pane" -c "$cwd")"
          right_pane="$(${pkgs.tmux}/bin/tmux split-window -h -P -F '#{pane_id}' -t "$center_pane" -c "$cwd")"
          ${pkgs.tmux}/bin/tmux select-layout -t "$target_window" even-horizontal >/dev/null
          launch_ide_yazi "$base_pane" "$center_pane" "$right_pane"
          run_in_pane "$center_pane" "${pkgs.helix}/bin/hx"
          ${pkgs.tmux}/bin/tmux select-pane -t "$base_pane"
          ${pkgs.tmux}/bin/tmux display-message "Applied layout: ide-3pane"
          ;;
        editor-2pane)
          editor_pane="$(${pkgs.tmux}/bin/tmux split-window -h -P -F '#{pane_id}' -t "$base_pane" -c "$cwd")"
          ${pkgs.tmux}/bin/tmux select-layout -t "$target_window" even-horizontal >/dev/null
          run_in_pane "$editor_pane" "${pkgs.helix}/bin/hx"
          ${pkgs.tmux}/bin/tmux select-pane -t "$editor_pane"
          ${pkgs.tmux}/bin/tmux display-message "Applied layout: editor-2pane"
          ;;
        agent-4pane)
          top_right_pane="$(${pkgs.tmux}/bin/tmux split-window -h -P -F '#{pane_id}' -t "$base_pane" -c "$cwd")"
          ${pkgs.tmux}/bin/tmux split-window -v -t "$base_pane" -c "$cwd"
          ${pkgs.tmux}/bin/tmux split-window -v -t "$top_right_pane" -c "$cwd"
          ${pkgs.tmux}/bin/tmux select-layout -t "$target_window" tiled >/dev/null
          ${pkgs.tmux}/bin/tmux select-pane -t "$base_pane"
          ${pkgs.tmux}/bin/tmux display-message "Applied layout: agent-4pane"
          ;;
        shell-3pane)
          middle_pane="$(${pkgs.tmux}/bin/tmux split-window -h -P -F '#{pane_id}' -t "$base_pane" -c "$cwd")"
          ${pkgs.tmux}/bin/tmux split-window -h -t "$middle_pane" -c "$cwd"
          ${pkgs.tmux}/bin/tmux select-layout -t "$target_window" even-horizontal >/dev/null
          ${pkgs.tmux}/bin/tmux select-pane -t "$base_pane"
          ${pkgs.tmux}/bin/tmux display-message "Applied layout: shell-3pane"
          ;;
        *)
          ${pkgs.tmux}/bin/tmux display-message "Unknown layout: $layout_name"
          exit 1
          ;;
      esac
    '';
  };

  layoutMenu = ''
    display-menu -T 'Window Layouts' \
      'IDE 3 Pane' i "run-shell '${tmuxLayoutApply}/bin/tmux-layout-apply ide-3pane #{window_id}'" \
      'Editor 2 Pane' e "run-shell '${tmuxLayoutApply}/bin/tmux-layout-apply editor-2pane #{window_id}'" \
      'Agent 4 Pane' a "run-shell '${tmuxLayoutApply}/bin/tmux-layout-apply agent-4pane #{window_id}'" \
      'Shell 3 Pane' s "run-shell '${tmuxLayoutApply}/bin/tmux-layout-apply shell-3pane #{window_id}'"
  '';
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "screen-256color";
    historyLimit = 10000;
    escapeTime = 0;
    baseIndex = 1;

    extraConfig = ''
      # Enable true color support for Ghostty.
      set -ga terminal-overrides ',xterm-ghostty:Tc,screen-256color:Tc'

      # Enable mouse support
      set -g mouse on

      # Slow copy-mode wheel scrolling down from tmux's default 5 lines per tick.
      bind -T copy-mode-vi WheelUpPane select-pane \; send-keys -X -N 1 scroll-up
      bind -T copy-mode-vi WheelDownPane select-pane \; send-keys -X -N 1 scroll-down
      bind -T copy-mode WheelUpPane select-pane \; send-keys -X -N 1 scroll-up
      bind -T copy-mode WheelDownPane select-pane \; send-keys -X -N 1 scroll-down

      # Dim inactive panes and give the focused pane a brighter border.
      # Gruvbox palette: active = default (#282828 bg0), inactive = darker (#1d2021 bg0_h).
      set -g window-style 'fg=#928374,bg=#1d2021'
      set -g window-active-style 'fg=default,bg=default'
      set -g pane-border-lines heavy
      set -g pane-border-style 'fg=colour240'
      set -g pane-active-border-style 'fg=colour45,bold'

      # Split panes without a prefix.
      bind -n M-n split-window -h
      bind -n M-N split-window -v

      # Jump to windows by index without a prefix.
      bind -n M-1 select-window -t :=1
      bind -n M-2 select-window -t :=2
      bind -n M-3 select-window -t :=3
      bind -n M-4 select-window -t :=4
      bind -n M-5 select-window -t :=5
      bind -n M-6 select-window -t :=6
      bind -n M-7 select-window -t :=7
      bind -n M-8 select-window -t :=8
      bind -n M-9 select-window -t :=9

      # Create a new window, then choose a predefined layout for it.
      bind -n M-t new-window -c '#{pane_current_path}' \; ${layoutMenu}

      # Create a plain new window from the current pane's directory.
      bind -n M-i new-window -c '#{pane_current_path}'

      # Apply a predefined layout to the current fresh window.
      bind I ${layoutMenu}

      # Switch panes using Alt-h/j/k/l without a prefix.
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Toggle zoom for the current pane without a prefix.
      bind -n M-f resize-pane -Z

      # Rename the current window without a prefix.
      bind -n M-r command-prompt -I "#W" "rename-window -- '%%'"

      # Reload config with r
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Status bar customization
      set -g status-position bottom
      set -g status-style 'bg=colour234 fg=colour137'
      set -g status-left ""
      set -g status-right '#[fg=colour233,bg=colour241,bold] %Y-%m-%d #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20

      setw -g window-status-current-style 'fg=colour1 bg=colour19 bold'
      setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

      setw -g window-status-style 'fg=colour9 bg=colour18'
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
    '';
  };
}
