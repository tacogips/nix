{ config, pkgs, lib, ... }:

{
  programs.aerospace = {
    enable = true;
    
    userSettings = {
      # Start AeroSpace automatically at login
      start-at-login = true;
      
      # Commands to run after AeroSpace startup
      after-startup-command = [
        "layout tiles"
      ];
      
      # Normalization settings
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      
      # Container settings
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      
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
        "ctrl-shift-h" = "focus left";
        "ctrl-shift-j" = "focus down";
        "ctrl-shift-k" = "focus up";
        "ctrl-shift-l" = "focus right";
        
        # Move windows
        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";
        
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
        
        # Service mode
        "alt-shift-semicolon" = "mode service";
      };
      
      # Service mode for advanced operations
      mode.service.binding = {
        "esc" = ["reload-config" "mode main"];
        "r" = ["flatten-workspace-tree" "mode main"];
        "f" = ["layout floating tiling" "mode main"];
        "backspace" = ["close-all-windows-but-current" "mode main"];
        
        # Move between monitors
        "h" = ["join-with left" "mode main"];
        "j" = ["join-with down" "mode main"];
        "k" = ["join-with up" "mode main"];
        "l" = ["join-with right" "mode main"];
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
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
    };
  };
}