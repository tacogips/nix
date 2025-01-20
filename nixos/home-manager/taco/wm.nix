{ config, pkgs, ... }:

{
  wayland.windowManager.river = {
    enable = true;
    extraPackages = with pkgs; [
      river
      waybar        # ステータスバー
      wofi         # アプリケーションランチャー
      wl-clipboard # クリップボードマネージャー
      grim         # スクリーンショット
      slurp        # 画面領域選択
      mako         # 通知デーモン
    ];

    # riverの設定
    settings = {
      # デフォルトのアプリケーション
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";

      # キーバインド
      bindings = {
        "Super+Return" = "spawn ${pkgs.alacritty}/bin/alacritty";
        "Super+q" = "close";
        "Super+Shift+q" = "exit";
        "Super+j" = "focus-view next";
        "Super+k" = "focus-view previous";
        "Super+Space" = "toggle-float";
        "Super+F" = "toggle-fullscreen";

        # ワークスペース
        "Super+1" = "workspace 1";
        "Super+2" = "workspace 2";
        "Super+3" = "workspace 3";
        "Super+4" = "workspace 4";
        
        # アプリケーションランチャー
        "Super+d" = "spawn ${pkgs.wofi}/bin/wofi --show drun";
      };

      # 外観設定
      background-color = "0x000000";
      border-width = 2;
      border-color-focused = "0x93a1a1";
      border-color-unfocused = "0x586e75";
    };
  };

  # 関連するサービスの設定
  services = {
    # ステータスバー
    waybar = {
      enable = true;
      settings = {
        # waybarの設定をここに記述
      };
    };

    # 通知デーモン
    mako = {
      enable = true;
      defaultTimeout = 5000;
    };
  };

  # 環境変数の設定
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "river";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };
}

