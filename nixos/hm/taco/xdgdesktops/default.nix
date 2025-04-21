{ config, pkgs, ... }:

let
  # We'll still import fish functions for reference, but create simplified bash versions
  fishFunctions = import ../fish/functions.nix { inherit pkgs; };
  
  # Create specific bash implementations for screenshot functions
  # These call fish with a specific function name rather than trying to inline the function content
  screenshotScripts = {
    capture_sel = pkgs.writeShellScriptBin "capture_sel" ''
      #!/bin/sh
      ${pkgs.fish}/bin/fish -c "capture_sel"
    '';
    
    capture_sel_video = pkgs.writeShellScriptBin "capture_sel_video" ''
      #!/bin/sh
      ${pkgs.fish}/bin/fish -c "capture_sel_video"
    '';
    
    capture_active = pkgs.writeShellScriptBin "capture_active" ''
      #!/bin/sh
      ${pkgs.fish}/bin/fish -c "capture_active"
    '';
  };

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
      ${pkgs.firefox}/bin/firefox "$URL"
    ''}/bin/open-url-from-file${toString num}";
    icon = "firefox";
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
    capture_sel = {
      name = "Screen Area Screenshot";
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
    capture_sel_video = {
      name = "Screen Area Video";
      comment = "Capture a video of a selected area of the screen";
      exec = "${screenshotScripts.capture_sel_video}/bin/capture_sel_video";
      icon = "camera-video";
      terminal = false;
      categories = [
        "Utility"
        "AudioVideo"
        "Video"
        "X-Screencast"
      ];
    };
    capture_active = {
      name = "Active Window Screenshot";
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
      "text/html" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "text/xml" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "default-web-browser" = "firefox.desktop";
    };
  };

}
