{ config, pkgs, lib, ... }:

{
  # Linux-specific Alacritty configuration
  programs.alacritty = {
    settings = {
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
    };
  };
}