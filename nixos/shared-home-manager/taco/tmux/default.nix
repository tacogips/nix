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

      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

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
