# Karabiner-Elements Keymap Tips

Tips learned while configuring `karabiner.nix` to match the Linux kana layout
on a US keyboard under macOS `Japanese - Kana` input.

## input_source_if Condition

### Correct input_source_id

The `input_source_if` condition must use the ID that **Karabiner-Elements**
recognises, not the one stored in `com.apple.HIToolbox.plist`.

| Source | ID |
| --- | --- |
| `com.apple.HIToolbox.plist` (wrong) | `com.apple.keylayout.KANA` |
| Karabiner-Elements (correct) | `com.apple.inputmethod.Kotoeri.KanaTyping.Japanese` |

### How to find the correct ID

1. Open **Karabiner-EventViewer**.
2. Go to the **Variables** tab.
3. Switch to the target input source.
4. Read `input_source.input_source_id`.

Alternatively, list all input sources programmatically:

```swift
swift -e '
import Carbon
let cond: CFDictionary = [:] as CFDictionary
if let sources = TISCreateInputSourceList(cond, true)?.takeRetainedValue() as? [TISInputSource] {
    for s in sources {
        let id = TISGetInputSourceProperty(s, kTISPropertyInputSourceID)
            .map { Unmanaged<CFString>.fromOpaque($0).takeUnretainedValue() as String }
        let mode = TISGetInputSourceProperty(s, kTISPropertyInputModeID)
            .map { Unmanaged<CFString>.fromOpaque($0).takeUnretainedValue() as String }
        if let id = id { print(id, mode ?? "") }
    }
}
'
```

### Common Japanese input source IDs

| Input Method | `input_source_id` |
| --- | --- |
| Kana typing (hiragana) | `com.apple.inputmethod.Kotoeri.KanaTyping.Japanese` |
| Kana typing (katakana) | `com.apple.inputmethod.Kotoeri.KanaTyping.Japanese.Katakana` |
| Romaji typing (hiragana) | `com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese` |
| Romaji typing (katakana) | `com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese.Katakana` |
| ABC (English) | `com.apple.keylayout.ABC` |

## Debugging a Rule That Does Not Fire

1. Add a minimal test rule (e.g. `=` to `a`) with the same condition.
2. Apply and switch to the target input source.
3. If the test character appears, the condition is correct and the issue is in
   the mapping logic.
4. If unchanged, the condition does not match — verify the `input_source_id`
   with EventViewer.

## Remap Strategies

### Direct key-event remap

The preferred approach. Karabiner intercepts key events at the hardware level,
**before** the macOS IME, so remapping `from` key_code to `to` key_code changes
what the IME receives.

```json
{
  "type": "basic",
  "from": { "key_code": "equal_sign" },
  "to": [{ "key_code": "backslash" }],
  "conditions": [...]
}
```

### shell_command (text injection)

Use only when the target character has no corresponding key on the Mac kana
layout (e.g. `む` does not appear on any US keyboard key in Mac kana mode).

```json
{
  "type": "basic",
  "from": { "key_code": "backslash" },
  "to": [{
    "shell_command": "/nix/store/...-karabiner-type-mu/bin/karabiner-type-mu"
  }],
  "conditions": [...]
}
```

The current Nix configuration builds this helper from an embedded Swift source
using `pkgs.swift`, then points Karabiner at the resulting store path. This is
faster than spawning `osascript` for every `む` keypress.

Requires **Accessibility** permission for Karabiner-Elements in System Settings
> Privacy & Security > Accessibility.

## Event Processing Order

Karabiner processes key events **before** the IME:

```
Hardware → Simple Modifications → Complex Modifications → Function Keys → macOS / IME
```

This means direct key-event remaps reliably change what kana character the IME
produces. The condition (`input_source_if`) is checked against the current input
source at event time.

## Nix Helper Functions

The `karabiner.nix` defines three helpers to reduce boilerplate:

| Helper | Use case |
| --- | --- |
| `mkKanaKeyRemap from to` | Normal key remap (no modifier) |
| `mkKanaKeyRemapWithModifiers from to mods` | Normal key remap with output modifiers |
| `mkKanaShiftRemap from to mods` | Shift+key remap with output modifiers |

All helpers automatically attach the `jaKanaCondition` and allow `caps_lock` as
an optional modifier.
