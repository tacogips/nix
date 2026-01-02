{ config, pkgs, ign-pkg, ... }:

{
  home.packages = [
    # ign - Template-based code generation CLI tool
    ign-pkg
  ];
}
