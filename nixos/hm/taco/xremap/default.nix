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
            #  with_mark = "down";
            #};

            #"C-p" = {
            #  with_mark = "up";
            #};

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
        #  name = "browser"; application = {
        #    #    only = "brave-browser";
        #    #only = [
        #    #  "firefox"
        #    #  "Mozilla Firefox"
        #    #];

        #    only = "firefox";
        #  };
        #  remap = {
        #    "C-a" = {
        #      with_mark = "home";
        #    };
        #    "C-e" = {
        #      with_mark = "end";
        #    };

        #    "C-p" = {
        #      with_mark = "up";
        #    };
        #    "C-n" = {
        #      with_mark = "down";
        #    };

        #    "C-k" = [

        #      "Shift-end"
        #      "C-x"
        #      { set_mark = false; }
        #    ];
        #  };
        #}

        #{
        #  name = "browser";
        #  application = {
        #    only = "firefox";
        #  };
        #  remap = {
        #    "C-j" = "F6";
        #  };
        #}

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
