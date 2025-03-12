{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    userName = "tacogips";
    userEmail = "me@tacogips.me";
    extraConfig = {
      core.editor = "zeditor";
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
    };
  };

}
