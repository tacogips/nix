# Mutability module for Home Manager files
# Based on: https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
{ config, lib, pkgs, ... }:

with lib;

let
  # Function to create a mutable file that can be modified outside of Nix
  mutabilityModule = { name, config, ... }: {
    options.mutable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether the file should be mutable (can be modified outside of Nix).
        When enabled, the file won't be removed when deleted from configuration
        and can be edited directly on the filesystem.
      '';
    };

    config = mkIf config.mutable {
      # Mark the file as forceable to allow modifications
      force = mkDefault true;

      # Use a different approach for mutable files
      onChange = mkIf (config.text != null) ''
        if [[ ! -f "${config.target}" ]] || [[ "$(cat "${config.target}")" != "${config.text}" ]]; then
          echo "Creating/updating mutable file: ${config.target}"
          cp "${config.source}" "${config.target}"
          chmod u+w "${config.target}"
        fi
      '';
    };
  };

in {
  options.home.file = mkOption {
    type = types.attrsOf (types.submodule mutabilityModule);
  };

  options.xdg.configFile = mkOption {
    type = types.attrsOf (types.submodule mutabilityModule);
  };

  options.xdg.dataFile = mkOption {
    type = types.attrsOf (types.submodule mutabilityModule);
  };

  config = {
    # Ensure XDG directories exist
    home.sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
    };
  };
}