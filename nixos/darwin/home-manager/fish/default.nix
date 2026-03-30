{
  pkgs,
  lib,
  config,
  ...
}:

let
  darwinFishFunctions = import ./functions.nix { inherit pkgs; };
  darwinFishAliases = import ./aliases.nix { inherit lib pkgs; };
in
{
  # Extend shared fish settings with Darwin-specific additions.
  programs.fish = {
    functions = darwinFishFunctions;
    shellAliases = darwinFishAliases;

    interactiveShellInit = lib.mkAfter ''
      # Disable greeting
      set fish_greeting

      # GUI terminals on macOS do not always inherit the Nix daemon profile.
      for nix_profile in \
        "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish" \
        "/nix/var/nix/profiles/default/etc/profile.d/nix.fish"
        if test -f "$nix_profile"
          source "$nix_profile"
          break
        end
      end

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
