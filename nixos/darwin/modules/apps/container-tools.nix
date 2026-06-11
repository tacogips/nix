{ config, lib, ... }:

let
  cfg = config.taco.darwin.apps.container-tools;
in
{
  options.taco.darwin.apps.container-tools.enable =
    lib.mkEnableOption "Docker and Podman tools installed with Homebrew";

  options.taco.darwin.apps.container-tools.startColimaService =
    lib.mkEnableOption "Colima Homebrew service startup";

  config = lib.mkIf cfg.enable {
    # Podman 5.8's AppleHV provider fails to keep the machine reachable on
    # this macOS setup; libkrun via krunkit is the working provider.
    taco.darwin.homebrew.taps = [ "slp/krunkit" ];
    taco.darwin.homebrew.trustedTaps = [ "slp/krunkit" ];

    homebrew = {
      enable = true;
      brews = [
        (
          {
            name = "colima";
          }
          // lib.optionalAttrs cfg.startColimaService {
            start_service = true;
          }
        )
        "container"
        "krunkit"
        "podman"
        "podman-compose"
        {
          name = "docker";
          conflicts_with = [ "docker-completion" ];
        }
        "docker-compose"
      ];
    };

    system.activationScripts.podmanMacHelper.text = ''
      if [ -x /opt/homebrew/bin/podman-mac-helper ]; then
        if ! /opt/homebrew/bin/podman-mac-helper install; then
          echo "Podman macOS helper install failed; Podman machine socket forwarding may not work"
        fi
      fi
    '';

    system.activationScripts.preActivation.text = ''
      for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew" ] && "$brew" list --formula docker-completion >/dev/null 2>&1; then
          "$brew" unlink docker-completion || true
        fi
      done
    '';
  };
}
