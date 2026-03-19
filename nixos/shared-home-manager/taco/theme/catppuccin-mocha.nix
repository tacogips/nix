{ pkgs }:

let
  palettePackage = pkgs.catppuccin.override {
    variant = "mocha";
    themeList = [ "palette" ];
  };
  palette = builtins.fromJSON (builtins.readFile "${palettePackage}/palette/palette.json");
in
palette.mocha.colors
