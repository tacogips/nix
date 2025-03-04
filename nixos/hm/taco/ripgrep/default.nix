{ pkgs, ... }:
{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--no-ignore"
      "--color always"
    ];
  };
}
