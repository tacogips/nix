{
  pkgs,
  lib,
  config,
  stablePkgs ? null,
  ...
}:

let
  zedSettings = import ./settings.nix { };
  zedKeymap = import ./keymap.nix { };
  zedExtensions = import ./extensions.nix { };
  zedTasks = import ./tasks.nix { };
  zedPackage =
    if pkgs.stdenv.isLinux then
      stablePkgs.symlinkJoin {
        name = "zed-editor-wrapped";
        paths = [ stablePkgs.zed-editor ];
        nativeBuildInputs = [ stablePkgs.makeWrapper ];
        postBuild = ''
          rm "$out/bin/zeditor"
          makeWrapper ${lib.getExe stablePkgs.zed-editor} "$out/bin/zeditor" \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stablePkgs.wayland ]} \
            --set XKB_CONFIG_ROOT ${stablePkgs.xkeyboard_config}/share/X11/xkb \
            --set XLOCALEDIR ${stablePkgs.xorg.libX11}/share/X11/locale

          ln -s zeditor "$out/bin/zed"
        '';
      }
    else
      null;
in
{
  # Disable the home-manager module since it's causing binary name conflicts
  programs.zed-editor.enable = false;

  # Add Zed directly to packages
  # On Darwin, zed-editor is installed via Homebrew (managed in flake.nix)
  # to avoid build issues with Metal shader compiler
  # On Linux, use zed-editor from the stable nixpkgs input.
  home.packages =
    with pkgs;
    [
      nixfmt
      nil
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [ zedPackage ];

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

  # Create global tasks.json file
  xdg.configFile."zed/tasks.json".text = builtins.toJSON zedTasks;
}
