{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.xcode;
  xcodeToolchain = import ../../../lib/apple-xcode-toolchain.nix;
in
{
  options.taco.darwin.apps.xcode.enable = lib.mkEnableOption "Xcode installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps.Xcode = 497799835;
    environment.variables = xcodeToolchain.environmentVariables;
    environment.systemPath = [ xcodeToolchain.toolchainBin ];

    system.activationScripts.xcodeToolchain.text = ''
      xcode_app="${xcodeToolchain.appPath}"
      developer_dir="${xcodeToolchain.developerDir}"

      if [ -d "$developer_dir" ]; then
        current="$(${xcodeToolchain.xcodeSelect} -p 2>/dev/null || true)"
        if [ "$current" != "$developer_dir" ]; then
          echo "Selecting Xcode developer directory at $developer_dir..."
          /usr/bin/sudo ${xcodeToolchain.xcodeSelect} -s "$developer_dir"
        fi

        if ! ${xcodeToolchain.xcrun} --find swift >/dev/null 2>&1; then
          echo "Warning: swift is not available from the selected Xcode toolchain."
          echo "Open Xcode once to finish first-run setup."
        elif ! ${xcodeToolchain.xcrun} xcodebuild -version >/dev/null 2>&1; then
          echo "Warning: xcodebuild is not usable yet."
          echo "Open Xcode once to finish first-run setup."
        else
          echo "Host Xcode toolchain is configured at $developer_dir."
        fi
      else
        echo "Xcode.app is not installed yet."
        echo "Install Xcode from the Mac App Store, then run darwin-rebuild switch again."
        echo "Nix supplies repository utilities only; swift, xcodebuild, and iOS Simulator come from host Xcode."
      fi
    '';
  };
}
