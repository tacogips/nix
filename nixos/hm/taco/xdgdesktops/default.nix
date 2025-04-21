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

  mkBookmarkEntry = bookmark_name: {
    name = "bookmark_${bookmark_name}";
    comment = "Open bookmark ${bookmark_name} with browser";
    exec = "${pkgs.writeShellScriptBin "open-url-from-file-${bookmark_name}" ''
      #!/bin/sh
      URL_FILE_PATH=~/.private/bookmarks/${bookmark_name}.txt
      URL=$(${pkgs.coreutils}/bin/cat $URL_FILE_PATH)
      ${pkgs.firefox}/bin/firefox "$URL"
    ''}/bin/open-url-from-file-${bookmark_name}";
    icon = "firefox";
    terminal = false;
    categories = [
      "Development"
      "Utility"
    ];
  };

  # Read bookmark names from .config/bookmark_list.txt if it exists, otherwise use default empty list
  # Format of bookmark_list.txt should be one bookmark name per line, e.g.:
  #
  # github_tacogips
  # github_jlsi
  # notion_notes
  # gdocs_spreadsheet
  # localhost_4001
  # github_lawgue_backend
  # slack_docs
  # lawgue_dev
  # gcalendar
  # grafana_lawgue
  # aws_console
  # gmail
  #
  # Each bookmark name will correspond to a file at ~/.private/bookmarks/{name}.txt
  # containing just the URL for that bookmark.
  #
  # For example:
  # ~/.private/bookmarks/github_tacogips.txt contains: https://github.com/tacogips
  # ~/.private/bookmarks/gmail.txt contains: https://mail.google.com/mail/u/0/#inbox
  bookmarkNames =
    let
      bookmarkFile = "${config.home.homeDirectory}/.config/bookmark_list.txt";
      fileExists = builtins.pathExists bookmarkFile;
    in
    if fileExists then pkgs.lib.splitString "\n" (builtins.readFile bookmarkFile) else [ ];

  # Filter out empty lines
  filteredBookmarkNames = builtins.filter (name: name != "") bookmarkNames;

  # Create bookmark entries from the names in the file
  bookmarkEntries = builtins.listToAttrs (
    map (name: {
      name = "bookmark_${name}";
      value = mkBookmarkEntry name;
    }) filteredBookmarkNames
  );

in
{
  # Create the bookmark_list.txt file
  home.file.".config/bookmark_list.txt".text = ''
    github_tacogips
    work_notion
    work_spreadsheet
    work_github
    work_github_backend
    work_slack
    work_slack_report
    work_grafana
    work_aws_console
    gcalendar
    gmail
    localhost_4001
  '';

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
    capture_sel_video = {
      name = "capture_sel_video: Screen Area Video";
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
