{
  config,
  lib,
  pkgs,
  dataRoot ? null, # Optional custom Docker data root path
  ...
}:

let
  # If dataRoot is not specified, Docker uses its default location (/var/lib/docker)
  customDataRoot = dataRoot;
in
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
      setSocketVariable = false;
    };
  }
  // lib.optionalAttrs (customDataRoot != null) {
    storageDriver = "overlay2";
    extraOptions = "--data-root=${customDataRoot}";
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    package = pkgs.nvidia-container-toolkit;
  };

  systemd.services.nvidia-container-toolkit-cdi-generator =
    lib.mkIf config.hardware.nvidia-container-toolkit.enable
      (
        let
          nvidiaCdiGenerator = pkgs.callPackage ./nvidia-cdi-generator-safe.nix {
            inherit (config.hardware.nvidia-container-toolkit)
              csv-files
              device-name-strategy
              discovery-mode
              mounts
              disable-hooks
              enable-hooks
              extraArgs
              ;
            nvidia-container-toolkit = config.hardware.nvidia-container-toolkit.package;
            nvidia-driver = config.hardware.nvidia.package;
          };
        in
        {
          serviceConfig = {
            ExecStart = lib.mkForce "${lib.getExe nvidiaCdiGenerator}";
            RuntimeDirectoryPreserve = "yes";
          };
        }
      );

  # deal with container error. setting rlimit type 8: operation not permitted for rootlessdocker
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@wheel";
      type = "hard";
      item = "memlock";
      value = "unlimited";
    }
  ];
}
