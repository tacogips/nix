{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.xcode;
  xcodeDeveloperDir = "/Applications/Xcode.app/Contents/Developer";
in
{
  options.taco.darwin.apps.xcode.enable = lib.mkEnableOption "Xcode installed from the Mac App Store";

  config = lib.mkIf cfg.enable {
    homebrew.enable = true;
    homebrew.masApps.Xcode = 497799835;

    system.activationScripts.xcodeToolchain.text = ''
      xcode_app="/Applications/Xcode.app"
      developer_dir="${xcodeDeveloperDir}"

      if [ -d "$developer_dir" ]; then
        current="$(/usr/bin/xcode-select -p 2>/dev/null || true)"
        if [ "$current" != "$developer_dir" ]; then
          echo "Selecting Xcode developer directory at $developer_dir..."
          /usr/bin/sudo /usr/bin/xcode-select -s "$developer_dir"
        fi

        if ! /usr/bin/xcrun --find swift >/dev/null 2>&1; then
          echo "Warning: swift is not available from the selected Xcode toolchain."
          echo "Open Xcode once to finish first-run setup."
        elif ! /usr/bin/xcrun xcodebuild -version >/dev/null 2>&1; then
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
