{
  pkgs,
  ...
}:

let
  linuxFishFunctions = import ./functions.nix { inherit pkgs; };
  linuxFishAliases = import ./aliases.nix { inherit pkgs; };
in
{
  # Extend existing fish functions instead of replacing them
  programs.fish.functions = linuxFishFunctions;

  # Extend existing fish aliases with Linux-specific ones
  programs.fish.shellAliases = linuxFishAliases;

  # Linux-specific fish configuration
  home.file.".config/fish/exports.fish" = {
    source = ./exports.fish;
  };
}
