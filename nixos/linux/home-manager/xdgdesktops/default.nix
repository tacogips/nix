{ lib, pkgs, ... }:

let
  # Browser desktop file names for easy switching
  browserDesktopFile = "brave-browser.desktop";
  browserIcon = "brave";
  browserPackage = pkgs.brave;
  browserExec = lib.getExe browserPackage;
  screenshotIcon = "applets-screenshooter";

  mkFishFunctionScript =
    functionName:
    pkgs.writeShellScriptBin functionName ''
      exec ${lib.getExe pkgs.fish} -c ${lib.escapeShellArg functionName}
    '';

  mkBookmarkEntry =
    bookmarkName:
    let
      launcher = pkgs.writeShellScriptBin "open-url-from-file-${bookmarkName}" ''
        url_file_path="$HOME/.private/bookmarks/${bookmarkName}.txt"

        if [ ! -r "$url_file_path" ]; then
          echo "Missing bookmark file: $url_file_path" >&2
          exit 1
        fi

        IFS= read -r url < "$url_file_path"
        exec ${browserExec} "$url"
      '';
    in
    {
      name = "Bookmark: ${bookmarkName}";
      comment = "Open bookmark ${bookmarkName} with browser";
      exec = "${launcher}/bin/open-url-from-file-${bookmarkName}";
      icon = browserIcon;
      terminal = false;
      categories = [
        "Development"
        "Utility"
      ];
    };

  mkScreenshotEntry =
    {
      functionName,
      name,
      comment,
    }:
    let
      launcher = mkFishFunctionScript functionName;
    in
    {
      inherit name comment;
      exec = "${launcher}/bin/${functionName}";
      icon = screenshotIcon;
      terminal = false;
      categories = [
        "Utility"
        "Graphics"
        "X-Screenshot"
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
  xdg.desktopEntries = bookmarkEntries // {
    nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };
    capture_sel = mkScreenshotEntry {
      functionName = "capture_sel";
      name = "capture_sel: Screen Area Screenshot";
      comment = "Capture a selected area of the screen";
    };
    capture_active = mkScreenshotEntry {
      functionName = "capture_active";
      name = "capture_active: Active Window Screenshot";
      comment = "Capture the currently active window";
    };
  };

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
      "text/html" = browserDesktopFile;
      "application/pdf" = browserDesktopFile;
      "application/xhtml+xml" = browserDesktopFile;
      "text/xml" = browserDesktopFile;
      "x-scheme-handler/ftp" = browserDesktopFile;
      "x-scheme-handler/http" = browserDesktopFile;
      "x-scheme-handler/https" = browserDesktopFile;
      "default-web-browser" = browserDesktopFile;
    };
  };

}
