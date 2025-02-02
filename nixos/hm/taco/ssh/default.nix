{ pkgs, ... }:
{

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519_github";
      };
    };
  };
  home.file.".ssh/authorized_keys" ={
    source = ./authorized_keys;

  };

}
