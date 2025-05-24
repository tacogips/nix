{ pkgs }:

let
  # Import shared aliases
  sharedAliases = import ../../../shared-home-manager/taco/fish/aliases.nix { inherit pkgs; };
  
  # Filter out Linux-specific aliases
  filteredAliases = builtins.removeAttrs sharedAliases [
    "update-taco-main"
    "ppp"
    "cdp"
    "mozc_config"
  ];
  
  # Darwin-specific aliases
  darwinAliases = {
    "update-taco-mac" = "darwin-rebuild switch --flake ~/nix/nixos/darwin#taco-mac";
    "brewup" = "brew update && brew upgrade";
    "o" = "open";
    "cleanup" = "find . -type f -name '*.DS_Store' -ls -delete";
  };

in
  # Merge filtered shared aliases with Darwin-specific ones
  filteredAliases // darwinAliases