{ pkgs, ... }:
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
      # Enable mouse support
      set -g mouse on

      # Increase contrast so the active pane is easier to spot.
      set -g pane-border-style 'fg=colour238'
      set -g pane-active-border-style 'fg=colour81,bold'

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

      # Create a new window from the current pane's directory.
      bind -n M-t new-window -c '#{pane_current_path}'

      # Switch panes using Alt-h/j/k/l without a prefix.
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Toggle zoom for the current pane without a prefix.
      bind -n M-f resize-pane -Z

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
