{ pkgs, ... }:

{
  # Linux-specific aliases
  mozc_config = "${pkgs.mozc}/lib/mozc/mozc_tool --mode=config_dialog";
}