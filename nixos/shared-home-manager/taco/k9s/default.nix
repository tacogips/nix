{ pkgs, ... }:
{
  programs.k9s = {
    enable = true;
    arguments = [
      "--no-ignore"
      "--color always"
    ];
  };
}
