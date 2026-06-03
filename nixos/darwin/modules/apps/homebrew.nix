{ config, lib, ... }:

{
  options.taco.darwin.homebrew.taps = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Homebrew taps required by reusable Darwin app modules.";
  };

  config = lib.mkIf config.homebrew.enable {
    homebrew.taps = lib.unique config.taco.darwin.homebrew.taps;

    homebrew.onActivation = {
      autoUpdate = lib.mkDefault true;
      upgrade = lib.mkDefault true;
      cleanup = lib.mkDefault "none";
    };

    system.activationScripts.preActivation.text = ''
      # Check for Homebrew in expected locations.
      if [ -f /opt/homebrew/bin/brew ] || [ -f /usr/local/bin/brew ]; then
        echo "Homebrew is installed"
      else
        echo "Homebrew not found!"
        echo "Please install Homebrew manually:"
        echo "  /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo ""
        echo "After installation, run 'darwin-rebuild switch' again."
        exit 1
      fi
    '';
  };
}
