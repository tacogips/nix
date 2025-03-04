{ pkgs, ... }:
let
  aliases = import ./aliases.nix;
  abbrs = import ./abbrs.nix;
in
{
  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellAbbrs = abbrs;
  };
}
