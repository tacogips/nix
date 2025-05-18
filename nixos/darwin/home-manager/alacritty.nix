{ config, pkgs, lib, ... }:

{
  # Darwin-specific Alacritty configuration
  programs.alacritty = {
    # We still want the shared configuration, but we'll override some settings
    settings = {
      # Override font settings for macOS
      font = lib.mkForce {
        size = 13.0; # Larger size for macOS
        
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
      
      # macOS-specific window settings
      window = {
        decorations = "buttonless"; # macOS-style window
        padding = {
          x = 5;
          y = 5;
        };
        dynamic_padding = true;
        startup_mode = "Windowed";
        
        # macOS-specific options
        option_as_alt = "Both"; # Use Option as Alt key
      };
      
      # Set fish as the default shell - use absolute path to fish
      shell = {
        program = "/run/current-system/sw/bin/fish";
        args = ["-l"];
      };
    };
  };

  # Just include standard key bindings without Ctrl+H mapping
  programs.alacritty.settings.keyboard.bindings = lib.mkForce [
    {
      # Increase font size
      action = "IncreaseFontSize";
      key = "Plus";
      mods = "Control";
    }
    {
      # Decrease font size
      action = "DecreaseFontSize";
      key = "Minus";
      mods = "Control";
    }
    {
      # Toggle ViMode
      key = "S";
      mods = "Alt";
      action = "ToggleViMode";
    }
  ];
}