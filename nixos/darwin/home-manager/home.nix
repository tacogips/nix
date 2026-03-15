{
  config,
  pkgs,
  firefox-addons,
  bravesearch-mcp-pkg,
  ...
}:

{
  imports = [
    # Darwin-specific modules
    ./alacritty.nix
    # ./firefox.nix
    ./brave.nix # Import Darwin-specific Brave configuration
    ./fish # Import Darwin-specific fish configuration
    ./aerospace.nix # AeroSpace window manager configuration
    ./zoom.nix # Zoom video conferencing application
    # Add any other Darwin-specific modules here
  ];

  # Darwin-specific input method settings (if needed)
  # i18n.inputMethod = { ... };

  # Darwin-specific environment variables
  home.sessionVariables = {
    # Zed is installed via Homebrew, so use the binary from PATH
    EDITOR = "zed";
    # Add any macOS-specific environment variables here
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    # XDG Base Directory settings for macOS
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  # Add Homebrew to PATH for all shells
  home.sessionPath = [
    "/opt/homebrew/bin"  # Apple Silicon
    "/usr/local/bin"     # Intel Mac
  ];

  # Darwin-specific packages
  home.packages = with pkgs; [
    # macOS-specific tools
    gh # GitHub CLI
    gnumake
    jq
    go-task
    tokei
    dust

    # Development tools specific to macOS
    nixfmt
    nixd # nix lsp

    # claude-code and codex: installed via Homebrew on Darwin

    # macOS applications
    slack
    obsidian
    google-chrome

    # Ensure coreutils is available for scripts
    coreutils

    # Add any macOS-specific packages here
    mas # Mac App Store CLI
    iterm2
    rectangle # Window management

    # ---- mcps -------------------------------
    bravesearch-mcp-pkg
  ];

  fonts = {
    fontconfig.enable = true;
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Disable manual pages on Darwin as man-db has Linux-specific dependencies (libcap)
  manual.manpages.enable = false;
  programs.man.enable = false;

  # macOS-specific configurations
  targets.darwin = {
    currentHostDefaults."com.apple.controlcenter".BatteryShowPercentage = true;
    defaults = {
      NSGlobalDomain = {
        # Finder and UI settings
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";

        # Keyboard settings
        InitialKeyRepeat = 15; # Normal minimum is 15 (225ms)
        KeyRepeat = 2; # Normal minimum is 2 (30ms)

        # Trackpad settings
        "com.apple.trackpad.enableSecondaryClick" = true;
      };

      # Finder settings
      "com.apple.finder" = {
        ShowPathbar = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
        _FXShowPosixPathInTitle = true;
        FXPreferredViewStyle = "clmv"; # Column view
      };

      # Dock settings
      "com.apple.dock" = {
        autohide = true;
        show-recents = false;
        tilesize = 48;
        minimize-to-application = true;
      };

      # Safari settings
      "com.apple.Safari" = {
        ShowFullURLInSmartSearchField = true;
        ShowStatusBar = true;
        AutoFillPasswords = false;
        AutoOpenSafeDownloads = false;
      };
    };
  };
}
