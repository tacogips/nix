{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    settings = {

      main = {
        font = "Iosevka:size=10";
      };
    };
  };
}

#local wezterm = require("wezterm")
#
#return {
#	font = wezterm.font("iosevka"),
#	font_size = 15,
#	color_scheme = "iceberg-dark",
#	enable_tab_bar = false,
#
#	-- disable ligature
#	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
#}
#   example = literalExpression ''
#        {
#          main = {
#            term = "xterm-256color";
#
#            font = "Fira Code:size=11";
#            dpi-aware = "yes";
#          };
#
#          mouse = {
#            hide-when-typing = "yes";
#          };
#        }
#      '';
#    };
#  #};
