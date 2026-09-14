{
  lib,
  pkgs,
  kinko-pkg ? null,
  ...
}:

lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = lib.optionals (kinko-pkg != null) [
    # kinko - CLI for issue/workflow operations
    kinko-pkg
  ];
}
