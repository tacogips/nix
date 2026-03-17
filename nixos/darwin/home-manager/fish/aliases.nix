{ pkgs }:

let
  # Import shared aliases
  sharedFish = import ../../../shared-home-manager/taco/fish/aliases.nix { inherit pkgs; };
  sharedAliases = sharedFish.aliases;

  # Darwin-specific aliases
  darwinAliases = {
    "nix-switch-taco-mac" = "darwin-rebuild switch --flake ~/nix/nixos/darwin#taco-mac";
    "brewup" = "brew update && brew upgrade";
    "o" = "open";
    "cleanup" = "find . -type f -name '*.DS_Store' -ls -delete";
  };

in
# Merge shared aliases with Darwin-specific ones
sharedAliases // darwinAliases
