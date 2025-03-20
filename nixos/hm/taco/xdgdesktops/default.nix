{ config, pkgs, ... }:

let

  #xdg.desktopEntries = {
  #  bookmark1 = {
  #    name = "bookmark1";
  #    comment = "open bookmark with browser";
  #    exec = "${pkgs.writeShellScriptBin "open-url-from-file1" ''
  #      #!/bin/sh
  #      URL_FILE_PATH=~/.private/bookmarks/1.txt
  #      URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)
  #
  #      ${pkgs.brave}/bin/brave "$URL"
  #    ''}/bin/open-url-from-file1 ";
  #    icon = "brave";
  #    terminal = false;
  #    categories = [
  #      "Development"
  #      "Utility"
  #    ];
  #  };
  #}

  bookmarkCount = 20;

  mkBookmarkEntry = num: {
    name = "bookmark${toString num}";
    comment = "Open bookmark ${toString num} with browser";
    exec = "${pkgs.writeShellScriptBin "open-url-from-file${toString num}" ''
      #!/bin/sh
      URL_FILE_PATH=~/.private/bookmarks/${toString num}.txt
      URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)
      ${pkgs.brave}/bin/brave "$URL"
    ''}/bin/open-url-from-file${toString num}";
    icon = "brave";
    terminal = false;
    categories = [
      "Development"
      "Utility"
    ];
  };
  range = builtins.genList (x: x + 1) bookmarkCount;
  bookmarkEntries = builtins.listToAttrs (
    map (num: {
      name = "bookmark${toString num}";
      value = mkBookmarkEntry num;
    }) range
  );

in
{
  # .desktop エントリの作成
  xdg.desktopEntries = bookmarkEntries // {
    nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/gif" = "feh.desktop";
      "image/bmp" = "feh.desktop";
      "image/tiff" = "feh.desktop";
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
    };
  };

}
