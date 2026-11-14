{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;

    # 基本設定
    settings = {
      main = {
        font = "Sans:size=12";
        terminal = "${pkgs.ghostty}/bin/ghostty";
        layer = "overlay"; # Wayland layer
        width = 50;
        horizontal-pad = 10;
        vertical-pad = 10;
        inner-pad = 5;
        lines = 15;
        prompt = "❯ ";
      };

      # 色の設定
      colors = {
        background = "282a36fa";
        text = "f8f8f2ff";
        match = "8be9fdff";
        selection = "44475aff";
        selection-text = "f8f8f2ff";
        selection-match = "8be9fdff";
        border = "bd93f9ff";
      };

      # ボーダー設定
      border = {
        width = 2;
        radius = 10;
      };

      # スタイル設定
      dmenu = {
        mode = "text";
      };
    };
  };
}
