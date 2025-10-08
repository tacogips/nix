{
  pkgs,
  lib,
  config,
  ...
}:

let
  zedSettings = import ./settings.nix { };
  zedKeymap = import ./keymap.nix { };
  zedExtensions = import ./extensions.nix { };
in
{
  # Disable the home-manager module since it's causing binary name conflicts
  programs.zed-editor.enable = false;

  # Add Zed directly to packages
  home.packages = with pkgs; [
    zed-editor
    nixfmt-rfc-style
    nil
  ];

  # Create mutable Zed settings using an activation script approach
  home.activation.zedSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ZED_CONFIG_DIR="$HOME/.config/zed"
        ZED_SETTINGS_FILE="$ZED_CONFIG_DIR/settings.json"

        # Create config directory if it doesn't exist
        mkdir -p "$ZED_CONFIG_DIR"

        # Only create the settings file if it doesn't exist (preserves user edits)
        if [ ! -f "$ZED_SETTINGS_FILE" ]; then
          cat > "$ZED_SETTINGS_FILE" << 'EOF'
    ${builtins.toJSON zedSettings}
    EOF
        fi
  '';

  # Create keymap.json file
  xdg.configFile."zed/keymap.json".text = builtins.toJSON zedKeymap;

  # Create extensions.json file with all the extensions
  xdg.configFile."zed/extensions.json".text = builtins.toJSON zedExtensions;
}
