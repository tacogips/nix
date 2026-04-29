{ pkgs, ... }:
{

  # the application can get with `hyprctl clients`
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
            # C-a" = "home";
            #"C-n" = {
            #  with_mark = "pagedown";
            #};

            #"C-p" = {
            #  with_mark = "pageup";
            #};
            "C-f" = {
              with_mark = "right";
            };
            "C-a" = {
              with_mark = "home";
            };
            "C-e" = {
              with_mark = "end";
            };
            "C-k" = [
              "Shift-end"
              "C-x"
              { set_mark = false; }
            ];

          };
        }

        #{
        #  name = "browser";
        #  application = {
        #    not = "dev.zed.Zed";
        #  };
        #  remap = {
        #    #"C-j" = "F6";
        #    "C-a" = "home";
        #  };
        #}

      ];
    };
  };
}
