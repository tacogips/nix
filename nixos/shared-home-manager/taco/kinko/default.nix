{ config, pkgs, kinko-pkg, ... }:

{
  home.packages = [
    # kinko - CLI for issue/workflow operations
    kinko-pkg
  ];
}
