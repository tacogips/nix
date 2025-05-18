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
    };
  };

  # Create a separate key binding configuration section to fix Ctrl+H
  programs.alacritty.settings.keyboard.bindings = lib.mkForce [
    {
      # Fix for Ctrl+H not working as backspace
      key = "H";
      mods = "Control";
      chars = "\\x08";
    }
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