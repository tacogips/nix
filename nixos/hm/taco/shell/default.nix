{ pkgs, ... }:
let aliases = import ./aliases.nix
{
  programs.fish = {
    enable = true;
    shellAliases = aliases
  };
}
