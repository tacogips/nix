{ pkgs, ... }:
{

  # the application can get with `hyprctl client`
  services.xremap = {
    enable = true;
    withHypr = true;
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

      keymap = [
        {
          name = "familier linux";
          remap = {
            "C-u" = "PAGEUP";
            "C-m" = "enter";
            "C-h" = "backspace";
            "C-n" = {
              with_mark = "down";
            };
            "C-p" = {
              with_mark = "up";
            };
          };
        }

        {
          name = "browser";
          application = {
            only = [
              "firefox"
              "brave-browser"
            ];
          };
          remap = {
            "C-j" = "F6";
          };
        }

      ];
    };
  };

}
