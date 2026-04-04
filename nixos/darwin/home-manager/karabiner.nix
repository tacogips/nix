{ config, pkgs, lib, ... }:

let
  jaKanaCondition = [
    {
      type = "input_source_if";
      input_sources = [
        {
          input_source_id = "^com\\.apple\\.inputmethod\\.Kotoeri\\.KanaTyping\\.Japanese$";
        }
      ];
    }
  ];

  mkKanaKeyRemap = fromKey: toKey: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers = { optional = [ "caps_lock" ]; };
    };
    to = [{ key_code = toKey; }];
    conditions = jaKanaCondition;
  };

  mkKanaKeyRemapWithModifiers = fromKey: toKey: toModifiers: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers = { optional = [ "caps_lock" ]; };
    };
    to = [{ key_code = toKey; modifiers = toModifiers; }];
    conditions = jaKanaCondition;
  };

  mkKanaShiftRemap = fromKey: toKey: toModifiers: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers = {
        mandatory = [ "shift" ];
        optional = [ "caps_lock" ];
      };
    };
    to = [{ key_code = toKey; modifiers = toModifiers; }];
    conditions = jaKanaCondition;
  };
in
{
  # Keyboard layout references:
  # - Custom layout: ./keyboard-layouts/us-linux-kana.keylayout
  # - Mapping notes:  ./keyboard-layouts/mac_keybind.md
  #
  # The custom .keylayout attempt is kept as reference. The active solution is
  # Karabiner remapping against the standard Japanese KANA input source.
  #
  # Direct key-event remaps are used where possible. shell_command with
  # osascript is used only for characters absent from the Mac kana layout.

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
            {
              description = "match Linux kana layout on US keyboard";
              manipulators = [
                (mkKanaKeyRemap "equal_sign" "backslash")
                {
                  type = "basic";
                  from = {
                    key_code = "backslash";
                    modifiers = { optional = [ "caps_lock" ]; };
                  };
                  to = [{
                    shell_command = "osascript -e 'tell application \"System Events\" to keystroke \"む\"'";
                  }];
                  conditions = jaKanaCondition;
                }
                (mkKanaKeyRemapWithModifiers "grave_accent_and_tilde" "quote" [ "shift" ])
                (mkKanaKeyRemap "close_bracket" "equal_sign")
                (mkKanaShiftRemap "equal_sign" "backslash" [ "shift" ])
                (mkKanaShiftRemap "hyphen" "close_bracket" [ "shift" ])
                (mkKanaShiftRemap "backslash" "open_bracket" [ "shift" ])
                (mkKanaShiftRemap "grave_accent_and_tilde" "quote" [ "shift" ])
                (mkKanaShiftRemap "close_bracket" "equal_sign" [ "shift" ])
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
}
