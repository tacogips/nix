{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Using julia_110 (1.10.x LTS) because julia 1.12.1 is currently broken in nixpkgs
    # See: https://hydra.nixos.org/job/nixpkgs/trunk/julia.x86_64-linux
    julia_110
  ];
}
