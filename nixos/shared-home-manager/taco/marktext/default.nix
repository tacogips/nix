{ config, pkgs, lib, ... }:

{
  # MarkText is not supported on Darwin (macOS)
  # Only install on Linux systems
  home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    marktext
  ]);
}
