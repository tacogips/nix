{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    userName = "tacogips";
    userEmail = "me@tacogips.me";
    extraConfig = {
      core.editor = "${pkgs.vim}/bin/vim";
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
    };
  };

}
