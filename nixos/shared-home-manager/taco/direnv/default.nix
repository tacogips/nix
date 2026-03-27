{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."direnv/direnv.toml".text = ''
    [global]
    bash_path = "${pkgs.bash}/bin/bash"
  '';

}
