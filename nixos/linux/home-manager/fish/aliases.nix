{ pkgs, ... }:

{
  # Linux-specific aliases
  mozc_config = "${pkgs.mozc}/lib/mozc/mozc_tool --mode=config_dialog";

  # NixOS rebuild alias
  nix-swhich-nix-dev-machine = "sudo nixos-rebuild switch --flake ~/nix/nixos/linux#nix-dev-machine";

}