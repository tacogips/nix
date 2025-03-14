{ pkgs, ... }:
{

  # the application can get with `hyprctl client`
  services.xremap = {
    enable = true;
    withHypr = true;
    config = {
      keypress_delay_ms = 20;
      #modmap = [
      #  {
      #    name = "Global";
      #    remap = {
      #      "CapsLock" = "Esc";
      #    };
      #  }
      #];

      keymap = [
        {
          name = "familier linux";
          remap = {
            "C-m" = "enter";
            "C-h" = "backspace";
            #"C-n" = {
            #  with_mark = "down";
            #};

            #"C-p" = {
            #  with_mark = "up";
            #};
          };
        }

        #{
        #  name = "browser";
        #  application = {
        #    only = "firefox";
        #  };
        #  remap = {
        #    "C-j" = "F6";
        #  };
        #}

      ];
    };
  };

}
