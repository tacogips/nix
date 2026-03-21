{ pkgs, ... }:

let
  colors = import ../theme/catppuccin-mocha.nix { inherit pkgs; };
in
{
  programs.lazygit = {
    enable = true;

    settings = {
      notARepository = "quit";
      gui = {
        theme = {
          activeBorderColor = [
            colors.blue.hex
            "bold"
          ];
          inactiveBorderColor = [ colors.subtext0.hex ];
          optionsTextColor = [ colors.blue.hex ];
          selectedLineBgColor = [ colors.surface0.hex ];
          cherryPickedCommitBgColor = [ colors.surface1.hex ];
          cherryPickedCommitFgColor = [ colors.blue.hex ];
          unstagedChangesColor = [ colors.red.hex ];
          defaultFgColor = [ colors.text.hex ];
          searchingActiveBorderColor = [ colors.yellow.hex ];
        };

        authorColors."*" = colors.lavender.hex;
      };
    };
  };
}
