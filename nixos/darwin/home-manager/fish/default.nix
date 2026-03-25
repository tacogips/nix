{
  pkgs,
  lib,
  config,
  ...
}:

let
  darwinFishFunctions = import ./functions.nix { inherit pkgs; };
  darwinFishAliases = import ./aliases.nix { inherit pkgs; };
in
{
  # Extend shared fish settings with Darwin-specific additions.
  programs.fish = {
    functions = darwinFishFunctions;
    shellAliases = darwinFishAliases;

    interactiveShellInit = lib.mkAfter ''
      # Disable greeting
      set fish_greeting

      # Keep Home Manager and Homebrew binaries visible in interactive fish.
      for fish_user_bin in \
        "$HOME/.local/bin" \
        "${config.home.profileDirectory}/bin" \
        "/opt/homebrew/bin" \
        "/usr/local/bin"
        if test -d "$fish_user_bin"
          fish_add_path --prepend "$fish_user_bin"
        end
      end

      # Darwin-specific key bindings
      bind -M insert ctrl-h backward-delete-char
      bind -M insert ctrl-a beginning-of-line
    '';
  };
}
