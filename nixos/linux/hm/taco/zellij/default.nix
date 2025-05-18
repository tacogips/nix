{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".config/zellij/config.kdl".source = ./zellij-config.kdl;
}
