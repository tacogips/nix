{
  lib,
  kinko-pkg ? null,
  ...
}:

{
  home.packages = lib.optionals (kinko-pkg != null) [
    # kinko - CLI for issue/workflow operations
    kinko-pkg
  ];
}
