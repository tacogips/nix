_:

let
  # These aliases are Darwin-only additions. Shared aliases are provided by the
  # shared module and merged by the Nix module system.
  darwinAliases = {
    "nix-switch-taco-mac" = "darwin-rebuild switch --flake ~/nix/nixos/darwin#taco-mac";
    "brewup" = "brew update && brew upgrade";
    "o" = "open";
    "cleanup" = "find . -type f -name '*.DS_Store' -ls -delete";
  };

in
darwinAliases
