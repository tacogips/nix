{ lib, ... }:

{
  imports = [
    ../../modules/base
    ../../modules/apps
    ../../profiles/home-server.nix
  ];

  networking = {
    computerName = lib.mkDefault "darwin-mac-home-server";
    hostName = lib.mkDefault "darwin-mac-home-server";
    localHostName = lib.mkDefault "darwin-mac-home-server";
  };
}
