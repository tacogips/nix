{ config, pkgs, ... }:

{
  # .desktop エントリの作成
  xdg.desktopEntries = {
    # アプリケーション名（ファイル名になります: my-custom-app.desktop）
    open_lawgue = {
      name = "My Custom Application";
      comment = "open browser";
      exec = "${pkgs.brave}/bin/brave %u"; # 実行するコマンド
      #icon = "path-to-icon-or-icon-name"; # アイコン
      terminal = false;
      categories = [
        "Development"
        "Utility"
      ];
    };

    ## 別の例：スクリプトを実行する.desktopファイル
    #my-script = {
    #  name = "My Script";
    #  genericName = "Utility Script";
    #  comment = "Run my custom script";
    #  exec = "${pkgs.writeShellScriptBin "my-script" ''
    #    #!/bin/sh
    #    echo "Hello, World!"
    #    ${pkgs.xmessage}/bin/xmessage "Script executed successfully!"
    #  ''}/bin/my-script";
    #  icon = "utilities-terminal";
    #  terminal = true;
    #  categories = [
    #    "Utility"
    #    "System"
    #  ];
    #};
  };
}
