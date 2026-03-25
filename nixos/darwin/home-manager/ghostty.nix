{ lib, ... }:

{
  taco.ghostty = {
    autoStartTmux = lib.mkForce true;
    fontFamily = lib.mkForce "JetBrainsMono Nerd Font";
    fontSize = lib.mkForce 13;
    extraConfig = lib.mkForce ''
      macos-titlebar-style = hidden
      macos-option-as-alt = true
      window-decoration = auto
      keybind = cmd+d=ignore
      keybind = cmd+n=ignore
    '';
  };
}
