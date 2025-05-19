{ pkgs, lib, config, ... }:

let
  linuxFishFunctions = import ./functions.nix { inherit pkgs; };
in
{
  # Extend existing fish functions instead of replacing them
  programs.fish.functions = linuxFishFunctions;
}