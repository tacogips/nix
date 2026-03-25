{ pkgs, ... }:
{
  programs.jujutsu.enable = true;

  programs.delta.enableJujutsuIntegration = true;

  home.packages = with pkgs; [
    lazyjj
  ];
}
