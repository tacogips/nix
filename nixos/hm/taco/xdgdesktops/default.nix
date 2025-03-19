{ config, pkgs, ... }:

{
  # .desktop エントリの作成
  xdg.desktopEntries = {
    bookmark1 = {
      name = "bookmark1";
      comment = "open bookmark with browser";
      exec = "${pkgs.writeShellScriptBin "open-url-from-file1" ''
        #!/bin/sh
        URL_FILE_PATH=~/.private/bookmarks/1.txt
        URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)

        ${pkgs.brave}/bin/brave "$URL"
      ''}/bin/open-url-from-file1 ";
      icon = "brave";
      terminal = false;
      categories = [
        "Development"
        "Utility"
      ];
    };

    bookmark2 = {
      name = "bookmark2";
      comment = "open bookmark with browser2";
      exec = "${pkgs.writeShellScriptBin "open-url-from-file" ''
        #!/bin/sh
        URL_FILE_PATH=~/.private/bookmarks/2.txt
        URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)

        ${pkgs.brave}/bin/brave "$URL"
      ''}/bin/open-url-from-file2 ";
      icon = "brave";
      terminal = false;
      categories = [
        "Development"
        "Utility"
      ];
    };

    bookmark3 = {
      name = "bookmark3";
      comment = "open bookmark with browser";
      exec = "${pkgs.writeShellScriptBin "open-url-from-file3" ''
        #!/bin/sh
        URL_FILE_PATH=~/.private/bookmarks/3.txt
        URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)

        ${pkgs.brave}/bin/brave "$URL"
      ''}/bin/open-url-from-file3 ";
      icon = "brave";
      terminal = false;
      categories = [
        "Development"
        "Utility"
      ];
    };

    ## run s
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/gif" = "feh.desktop";
      "image/bmp" = "feh.desktop";
      "image/tiff" = "feh.desktop";
      # 必要に応じて他の画像形式も追加
    };
  };

}
