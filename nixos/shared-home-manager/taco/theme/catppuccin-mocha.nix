{ pkgs }:

let
  palettePackage = pkgs.catppuccin.override {
    variant = "mocha";
    themeList = [ "palette" ];
  };
  # The palette install phase copies this JSON unchanged. Read its source so
  # configuration evaluation does not build a target-platform theme package.
  paletteSource = builtins.head palettePackage.srcs;
  palette = builtins.fromJSON (builtins.readFile "${paletteSource}/palette.json");
in
palette.mocha.colors
