{ config, pkgs, lib, ... }:

{
  # Keyboard layout references:
  # - Custom layout: ./keyboard-layouts/us-linux-kana.keylayout
  # - Mapping notes:  ./keyboard-layouts/mac_keybind.md
  #
  # Keep the .keylayout and the Markdown mapping notes in sync when editing
  # the US/Linux kana layout.

  # Karabiner-Elements configuration
  home.file.".config/karabiner/karabiner.json" = {
    text = builtins.toJSON {
    profiles = [
      {
        complex_modifications = {
          rules = [
            {
              description = "change ctrl+m to enter";
              manipulators = [
                {
                  from = {
                    key_code = "m";
                    modifiers = { mandatory = ["control"]; };
                  };
                  to = [{ key_code = "return_or_enter"; }];
                  type = "basic";
                }
              ];
            }
          ];
        };
        name = "Default profile";
        selected = true;
        simple_modifications = [
          {
            from = { key_code = "caps_lock"; };
            to = [{ key_code = "left_control"; }];
          }
        ];
        virtual_hid_keyboard = { keyboard_type_v2 = "ansi"; };
      }
    ];
    };
    force = true;  # Allow Home Manager to overwrite existing files
  };

  home.activation.installUsLinuxKanaKeylayout = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    layout_dir="$HOME/Library/Keyboard Layouts"
    layout_name="US Linux Kana.keylayout"
    mkdir -p "$layout_dir"

    if [ -L "$layout_dir/$layout_name" ]; then
      rm -f "$layout_dir/$layout_name"
    fi

    cp -f ${./keyboard-layouts/us-linux-kana.keylayout} "$layout_dir/$layout_name"
  '';
}
