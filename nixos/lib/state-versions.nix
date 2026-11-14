{
  lib,
  stateVersionsConfigEnv ? "NIX_STATE_VERSIONS_CONFIG",
}:
let
  stateVersionsConfigPath = builtins.getEnv stateVersionsConfigEnv;
  overridePath =
    if stateVersionsConfigPath == "" then
      null
    else if lib.hasPrefix "/" stateVersionsConfigPath then
      /. + stateVersionsConfigPath
    else
      throw "${stateVersionsConfigEnv} must be an absolute path.";

  defaults = {
    # This is a compatibility version, not a "latest release" knob.
    # Keep the default at the release used for the machine's first install.
    nixos = {
      default = {
        system = "24.11";
        home = "24.11";
      };
      hosts = { };
    };

    # nix-darwin keeps its own integer system.stateVersion scheme.
    darwin = {
      default = {
        system = 4;
        home = "24.11";
      };
      hosts = { };
    };
  };

  overrides =
    if overridePath != null && builtins.pathExists overridePath then import overridePath else { };

  merged = lib.recursiveUpdate defaults overrides;
  resolveHost =
    platform: host:
    lib.recursiveUpdate merged.${platform}.default (merged.${platform}.hosts.${host} or { });
in
merged
// {
  forNixosHost = host: resolveHost "nixos" host;
  forDarwinHost = host: resolveHost "darwin" host;
}
