{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    fish
    bash
    gcc # needed for rust
    clang # needed for rust
    stdenv.cc.cc.lib
    lm_sensors
  ];
}