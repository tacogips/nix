{ pkgs, ... }:

let
  colors = import ../theme/catppuccin-mocha.nix { inherit pkgs; };
in
{
  programs.lazydocker = {
    enable = true;
    package = null;

    settings.gui.theme = {
      activeBorderColor = [
        colors.blue.hex
        "bold"
      ];
      inactiveBorderColor = [ colors.subtext0.hex ];
      optionsTextColor = [ colors.blue.hex ];
      selectedLineBgColor = [ colors.surface0.hex ];
    };
  };
}
