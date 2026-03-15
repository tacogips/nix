{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Julia is currently broken in nixpkgs due to GCC 14 incompatibility
    # Both julia (1.12.1) and julia_110 (1.10.10) fail to build
    # Hydra status:
    #   - https://hydra.nixos.org/job/nixpkgs/trunk/julia.x86_64-linux
    #   - https://hydra.nixos.org/job/nixpkgs/trunk/julia_110.x86_64-linux
    # Tracking issue: https://github.com/NixOS/nixpkgs/issues/388196
    # Fix PR: https://github.com/NixOS/nixpkgs/pull/375959
    # julia  # Temporarily disabled: broken in nixpkgs (gcc 14 issue)
  ];
}
