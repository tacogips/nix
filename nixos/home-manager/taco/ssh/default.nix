{ pkgs, ... }:
{

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519_github";
      };

      mother = {
        identityFile = "~/.ssh/id_ed25519_mother";
        hostname = "192.168.11.5";
        user = "tacogips";
        port = 23422;
      };
    };
  };
}
