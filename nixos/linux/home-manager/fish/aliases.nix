{ pkgs, ... }:

{
  # Linux-specific aliases
  # Open Mozc settings to switch Japanese input style, such as Kana to Romaji.
  mozc_config = "${pkgs.mozc}/lib/mozc/mozc_tool --mode=config_dialog";

  # NixOS rebuild alias
  nix-swhich-nix-dev-machine = "sudo nixos-rebuild switch --flake ~/nix/nixos/linux#nix-dev-machine";

}
