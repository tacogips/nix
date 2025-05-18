{ pkgs, ... }:
{
  programs.fd = {
    enable = true;
    extraOptions = [
      #"--no-ignore"
    ];
  };

}
