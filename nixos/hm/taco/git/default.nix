{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    userName = "tacogips";
    userEmail = "me@tacogips.me";
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
    };
  };

}
