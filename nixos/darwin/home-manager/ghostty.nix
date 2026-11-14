{ lib, ... }:

{
  taco.ghostty = {
    fontFamily = lib.mkForce "JetBrainsMono Nerd Font";
    fontSize = lib.mkForce 15;
    extraConfig = lib.mkForce ''
      font-family = Noto Sans Mono CJK JP
      macos-titlebar-style = hidden
      macos-option-as-alt = true
      keybind = cmd+d=ignore
      keybind = cmd+n=ignore
    '';
  };
}
