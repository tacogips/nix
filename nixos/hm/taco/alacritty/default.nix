{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = "0x6b7089";
          blue = "0x91acd1";
          cyan = "0x95c4ce";
          green = "0xc0ca8e";
          magenta = "0xada0d3";
          red = "0xe98989";
          white = "0xd2d4de";
          yellow = "0xe9b189";
        };

        cursor = {
          cursor = "0xd2d4de";
          text = "0x6b7089";
        };

        normal = {
          black = "0x6b7089";
          blue = "0x91acd1";
          cyan = "0x95c4ce";
          green = "0xc0ca8e";
          magenta = "0xada0d3";
          red = "0xe98989";
          white = "0xd2d4de";
          yellow = "0xe9b189";
        };

        primary = {
          background = "0x161821";
          foreground = "0xd2d4de";
        };
      };

      font = {
        size = 11.0;

        bold = {
          family = "iosevka";
          style = "Bold";
        };

        bold_italic = {
          family = "iosevka";
          style = "Bold Italic";
        };

        italic = {
          family = "iosevka";
          style = "Italic";
        };

        normal = {
          family = "iosevka";
          style = "Regular";
        };
      };

      keyboard.bindings = [
        {
          action = "IncreaseFontSize";
          key = "Plus";
          mods = "Control";
        }
        {
          action = "DecreaseFontSize";
          key = "Minus";
          mods = "Control";
        }
        {
          key = "S";
          mods = "Alt";
          action = "ToggleViMode";
        }
      ];

      scrolling = {
        history = 10000;
      };
    };
  };
}
