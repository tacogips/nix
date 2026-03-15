{
  config,
  pkgs,
  lib,
  ...
}:

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

      # Set fish as the default shell - use Nix store path
      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [ "-l" ];
      };

      # macOS key bindings for copy and paste
      keyboard.bindings = [
        {
          key = "C";
          mods = "Super";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Super";
          action = "Paste";
        }
      ];
    };
  };

  # Use default Alacritty key bindings to preserve Ctrl-H, Ctrl-A, etc.
  # Font size can be controlled with Cmd+Plus/Minus on macOS by default
  # Vi mode can be toggled with default Alacritty shortcuts if needed
}
