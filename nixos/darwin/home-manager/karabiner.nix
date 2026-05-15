{
  config,
  pkgs,
  lib,
  ...
}:

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
      modifiers = {
        optional = [ "caps_lock" ];
      };
    };
    to = [ { key_code = toKey; } ];
    conditions = jaKanaCondition;
  };

  mkKanaKeyRemapWithModifiers = fromKey: toKey: toModifiers: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers = {
        optional = [ "caps_lock" ];
      };
    };
    to = [
      {
        key_code = toKey;
        modifiers = toModifiers;
      }
    ];
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
    to = [
      {
        key_code = toKey;
        modifiers = toModifiers;
      }
    ];
    conditions = jaKanaCondition;
  };

  # Restore ANSI symbol behavior outside of kana input mode.
  # virtual_hid_keyboard = "jis" makes macOS interpret several ASCII
  # symbol keys per JIS layout, which is undesirable in English/Roman
  # mode on a US ANSI physical keyboard.
  notKanaCondition = [
    {
      type = "input_source_unless";
      input_sources = [
        {
          input_source_id = "^com\\.apple\\.inputmethod\\.Kotoeri\\.KanaTyping\\.Japanese$";
        }
      ];
    }
  ];

  mkAnsiRemap =
    fromKey: fromMods: toKey: toMods:
    let
      fromModifiers =
        if fromMods == [ ] then
          { optional = [ "caps_lock" ]; }
        else
          {
            mandatory = fromMods;
            optional = [ "caps_lock" ];
          };
      toEntry =
        if toMods == [ ] then
          { key_code = toKey; }
        else
          {
            key_code = toKey;
            modifiers = toMods;
          };
    in
    {
      type = "basic";
      from = {
        key_code = fromKey;
        modifiers = fromModifiers;
      };
      to = [ toEntry ];
      conditions = notKanaCondition;
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
  # virtual_hid_keyboard.keyboard_type_v2 is set to "jis" so that macOS
  # interprets the `backslash` HID code as the JIS `]` position. In Kotoeri
  # kana mode this position is む — which is the character missing on the
  # ANSI kana layout. As a side effect, `equal_sign` also natively produces
  # へ under JIS, matching the Linux layout in mac_keybind.md.
  #
  # Note: switching the virtual keyboard to JIS changes a few shifted
  # ASCII symbols system-wide (e.g. Shift+2 → " instead of @). Add
  # restoration rules below if those become a problem in non-kana mode.
  #
  # References:
  # - Karabiner: Set keyboard type
  #   https://karabiner-elements.pqrs.org/docs/manual/configuration/configure-keyboard-type/
  # - Karabiner: Symbols differ on non-ANSI keyboards
  #   https://karabiner-elements.pqrs.org/docs/help/troubleshooting/symbols-with-non-ansi-keyboard/
  # - Issue #2900: backslash key_code generates ] on JIS
  #   https://github.com/pqrs-org/Karabiner-Elements/issues/2900
  # - Tony: How I configured my US external keyboard for my Japanese MacBook Pro
  #   https://medium.com/@trouve.antoine/how-i-configured-my-us-external-keyboard-for-my-japanese-macbook-pro-95e8bfea0f8f
  # - did2memo: Karabiner-Elements 記号テーブル (JIS/US key_code 対応表)
  #   https://did2memo.net/2019/03/31/karabiner-elements-symbol-table/

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
                      modifiers = {
                        mandatory = [ "control" ];
                      };
                    };
                    to = [ { key_code = "return_or_enter"; } ];
                    type = "basic";
                  }
                ];
              }
              {
                description = "restore ANSI symbol layout outside kana mode";
                manipulators = [
                  # Shift + number row
                  (mkAnsiRemap "2" [ "shift" ] "open_bracket" [ ])
                  (mkAnsiRemap "6" [ "shift" ] "equal_sign" [ ])
                  (mkAnsiRemap "7" [ "shift" ] "6" [ "shift" ])
                  (mkAnsiRemap "8" [ "shift" ] "quote" [ "shift" ])
                  (mkAnsiRemap "9" [ "shift" ] "8" [ "shift" ])
                  (mkAnsiRemap "0" [ "shift" ] "9" [ "shift" ])
                  # Hyphen / equal
                  (mkAnsiRemap "hyphen" [ "shift" ] "international1" [ "shift" ])
                  (mkAnsiRemap "equal_sign" [ ] "hyphen" [ "shift" ])
                  (mkAnsiRemap "equal_sign" [ "shift" ] "semicolon" [ "shift" ])
                  # Grave / tilde
                  (mkAnsiRemap "grave_accent_and_tilde" [ ] "open_bracket" [ "shift" ])
                  (mkAnsiRemap "grave_accent_and_tilde" [ "shift" ] "equal_sign" [ "shift" ])
                  # Brackets
                  (mkAnsiRemap "open_bracket" [ ] "close_bracket" [ ])
                  (mkAnsiRemap "open_bracket" [ "shift" ] "close_bracket" [ "shift" ])
                  (mkAnsiRemap "close_bracket" [ ] "backslash" [ ])
                  (mkAnsiRemap "close_bracket" [ "shift" ] "backslash" [ "shift" ])
                  # Backslash / pipe
                  (mkAnsiRemap "backslash" [ ] "international1" [ ])
                  (mkAnsiRemap "backslash" [ "shift" ] "international3" [ "shift" ])
                  # Semicolon / colon
                  (mkAnsiRemap "semicolon" [ "shift" ] "quote" [ ])
                  # Quote / double-quote
                  (mkAnsiRemap "quote" [ ] "7" [ "shift" ])
                  (mkAnsiRemap "quote" [ "shift" ] "2" [ "shift" ])
                ];
              }
              {
                description = "match Linux kana layout on US keyboard";
                manipulators = [
                  # Under JIS virtual keyboard, US `=` natively → へ and US `\`
                  # natively → む in kana mode, so no remap is needed for those.
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
              from = {
                key_code = "caps_lock";
              };
              to = [ { key_code = "left_control"; } ];
            }
          ];
          virtual_hid_keyboard = {
            keyboard_type_v2 = "jis";
          };
        }
      ];
    };
    force = true; # Allow Home Manager to overwrite existing files
  };
}
