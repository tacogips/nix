{
  lib,
  ign-pkg ? null,
  ...
}:

{
  home.packages = lib.optionals (ign-pkg != null) [
    # ign - Template-based code generation CLI tool
    ign-pkg
  ];
}
