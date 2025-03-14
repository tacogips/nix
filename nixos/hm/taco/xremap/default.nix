{ pkgs, ... }:
{

  services.xremap = {
    enable = true;
    withHypr = true;
    # Modmap for single key rebinds
    config = {
      keypress_delay_ms = 10;
      modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Esc";
          };
        }
      ];

      # Keymap for key combo rebinds
      keymap = [
        {
          name = "Example ctrl-u > pageup rebind";
          remap = {
            "C-u" = "PAGEUP";
          };
        }
      ];
    };
  };

}
