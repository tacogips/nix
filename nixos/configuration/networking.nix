{ config, lib, pkgs, ... }:

{
  networking.extraHosts = ''
    127.0.0.1 mongo1 mongo2 mongo3
  '';
}