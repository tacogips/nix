{ pkgs, ... }:
let
  sqliteLibraryExtension = if pkgs.stdenv.isDarwin then "dylib" else "so";
in
{
  settings.vim = {
    extraPackages = [ pkgs.sqlite ];

    extraPlugins = {
      "sqlite-lua".package = pkgs.vimPlugins.sqlite-lua;
      "smart-open".package = pkgs.vimPlugins.smart-open-nvim;
    };

    globals.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.${sqliteLibraryExtension}";
  };
}
