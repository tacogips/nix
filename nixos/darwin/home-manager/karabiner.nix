{ config, pkgs, lib, ... }:

let
  jaHiraganaCondition = [
    {
      type = "input_source_if";
      input_sources = [
        {
          language = "^ja$";
          input_mode_id = "^com\\.apple\\.inputmethod\\.Japanese\\.Hiragana$";
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
    conditions = jaHiraganaCondition;
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
    conditions = jaHiraganaCondition;
  };

  mkKanaTextRemap = fromKey: text: shift: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers =
        if shift then
          {
            mandatory = [ "shift" ];
            optional = [ "caps_lock" ];
          }
        else
          { optional = [ "caps_lock" ]; };
    };
    to = [
      {
        shell_command = "osascript -e 'tell application \"System Events\" to keystroke \"${text}\"'";
      }
    ];
    conditions = jaHiraganaCondition;
  };
in
{
  # Keyboard layout references:
  # - Custom layout: ./keyboard-layouts/us-linux-kana.keylayout
  # - Mapping notes:  ./keyboard-layouts/mac_keybind.md
  #
  # The custom .keylayout attempt is kept as reference. The active solution is
  # Karabiner remapping against the standard Japanese Hiragana input source.

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
                (mkKanaTextRemap "backslash" "む" false)
                (mkKanaKeyRemap "grave_accent_and_tilde" "quote")
                (mkKanaKeyRemap "close_bracket" "equal_sign")
                (mkKanaTextRemap "semicolon" "れ" false)
                (mkKanaTextRemap "z" "つ" false)
                (mkKanaShiftRemap "equal_sign" "backslash" [ "shift" ])
                (mkKanaShiftRemap "hyphen" "close_bracket" [ ])
                (mkKanaShiftRemap "backslash" "open_bracket" [ "shift" ])
                (mkKanaShiftRemap "grave_accent_and_tilde" "quote" [ "shift" ])
                (mkKanaShiftRemap "close_bracket" "equal_sign" [ "shift" ])
                (mkKanaTextRemap "semicolon" "れ" true)
                (mkKanaTextRemap "z" "つ" true)
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
