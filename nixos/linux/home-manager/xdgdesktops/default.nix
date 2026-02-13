{ config, pkgs, ... }:

let
  # Browser desktop file names for easy switching
  defaultBrowser = "brave-browser.desktop";
  browserIcon = "brave";
  browserPackage = pkgs.brave;
  browserBinary = "brave";

  # We'll still import fish functions for reference, but create simplified bash versions
  fishFunctions = import ../fish/functions.nix { inherit pkgs; };

  # Create specific bash implementations for screenshot functions
  # These call fish with a specific function name rather than trying to inline the function content
  screenshotScripts = {
    capture_sel = pkgs.writeShellScriptBin "capture_sel" ''
      #!/bin/sh
      ${pkgs.fish}/bin/fish -c "capture_sel"
    '';

    capture_active = pkgs.writeShellScriptBin "capture_active" ''
      #!/bin/sh
      ${pkgs.fish}/bin/fish -c "capture_active"
    '';
  };

  mkBookmarkEntry = bookmark_name: {
    name = "bookmark_${bookmark_name}";
    comment = "Open bookmark ${bookmark_name} with browser";
    exec = "${pkgs.writeShellScriptBin "open-url-from-file-${bookmark_name}" ''
      #!/bin/sh
      URL_FILE_PATH=~/.private/bookmarks/${bookmark_name}.txt
      URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)
      ${browserPackage}/bin/${browserBinary} "$URL"
    ''}/bin/open-url-from-file-${bookmark_name}";
    icon = browserIcon;
    terminal = false;
    categories = [
      "Development"
      "Utility"
    ];
  };

  # Import bookmarkNames from separate file
  bookmarks = import ./bookmarks.nix;
  bookmarkNames = bookmarks.bookmarkNames;
  # Create bookmark entries from the names in the file
  bookmarkEntries = builtins.listToAttrs (
    map (name: {
      name = "bookmark_${name}";
      value = mkBookmarkEntry name;
    }) bookmarkNames
  );

in
{
  # .desktop エントリの作成
  xdg.desktopEntries = bookmarkEntries // {
    nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };
    capture_sel = {
      name = "capture_sel: Screen Area Screenshot";
      comment = "Capture a selected area of the screen";
      exec = "${screenshotScripts.capture_sel}/bin/capture_sel";
      icon = "applets-screenshooter";
      terminal = false;
      categories = [
        "Utility"
        "Graphics"
        "X-Screenshot"
      ];
    };
    capture_active = {
      name = "capture_active: Active Window Screenshot";
      comment = "Capture the currently active window";
      exec = "${screenshotScripts.capture_active}/bin/capture_active";
      icon = "applets-screenshooter";
      terminal = false;
      categories = [
        "Utility"
        "Graphics"
        "X-Screenshot"
      ];
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
      "text/html" = defaultBrowser;
      "application/pdf" = defaultBrowser;
      "application/xhtml+xml" = defaultBrowser;
      "text/xml" = defaultBrowser;
      "x-scheme-handler/ftp" = defaultBrowser;
      "x-scheme-handler/http" = defaultBrowser;
      "x-scheme-handler/https" = defaultBrowser;
      "default-web-browser" = defaultBrowser;
    };
  };

}
