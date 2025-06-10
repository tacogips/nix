{ config, pkgs, lib, ... }:

{
  # Karabiner-Elements configuration
  home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
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
}