{ pkgs, ... }:
{

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = { };
  };
}
