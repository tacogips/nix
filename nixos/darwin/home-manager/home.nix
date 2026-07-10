{
  config,
  pkgs,
  lib,
  ...
}:

let
  xcodeToolchain = import ../../lib/apple-xcode-toolchain.nix;
in
{
  imports = [
    # Darwin-specific modules
    ./ghostty.nix
    ./fish # Import Darwin-specific fish configuration
    ./aerospace.nix # AeroSpace window manager configuration
    # Add any other Darwin-specific modules here
  ];

  # Darwin-specific input method settings (if needed)
  # i18n.inputMethod = { ... };

  # Darwin-specific environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    # Add any macOS-specific environment variables here
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    DEVELOPER_DIR = xcodeToolchain.developerDir;
    SDKROOT = xcodeToolchain.sdkRoot;
    TOOLCHAINS = xcodeToolchain.toolchainIdentifier;

    # XDG Base Directory settings for macOS
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  # Add Homebrew to PATH for all shells
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    xcodeToolchain.toolchainBin
    "/opt/homebrew/bin" # Apple Silicon
    "/usr/local/bin" # Intel Mac
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

    # claude-code: installed via Homebrew on Darwin
    # codex: installed by the activation hook below through the official installer
    # cursor-cli: installed via shared Home Manager config on Darwin

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

  ];

  fonts = {
    fontconfig.enable = true;
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Temporary workaround for Codex CLI package layouts that do not include
  # codex-code-mode-host next to the Homebrew-installed codex binary. Revisit
  # this when a newer Codex/Homebrew release consistently ships a working host.
  home.activation.codexCliStandalone = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Installing latest Codex CLI with the official standalone installer..."
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$HOME/.local/bin"
    if [ -z "''${DRY_RUN_CMD:-}" ]; then
      # The upstream installer currently shells out to standard text/archive
      # tools while resolving and unpacking release assets. This PATH can be
      # trimmed if a future installer no longer depends on these external tools.
      export PATH="${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.curl
          pkgs.findutils
          pkgs.gawk
          pkgs.gnugrep
          pkgs.gnused
          pkgs.gnutar
          pkgs.gzip
        ]
      }:$PATH"
      ${pkgs.curl}/bin/curl -fsSL https://chatgpt.com/codex/install.sh \
        | CODEX_NON_INTERACTIVE=1 \
          CODEX_RELEASE=latest \
          CODEX_INSTALL_DIR="$HOME/.local/bin" \
          sh
    fi
  '';

  home.activation.dockerCliPluginsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    docker_config_dir="$HOME/.docker"
    docker_config_file="$docker_config_dir/config.json"
    docker_config_tmp="$docker_config_file.tmp"
    docker_cli_plugin_dirs='["/opt/homebrew/lib/docker/cli-plugins","/usr/local/lib/docker/cli-plugins"]'

    $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$docker_config_dir"

    if [ -f "$docker_config_file" ]; then
      if ${pkgs.jq}/bin/jq -e . "$docker_config_file" >/dev/null; then
        ${pkgs.jq}/bin/jq --argjson dirs "$docker_cli_plugin_dirs" \
          '.cliPluginsExtraDirs = (((.cliPluginsExtraDirs // []) + $dirs) | unique)' \
          "$docker_config_file" > "$docker_config_tmp"
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/mv "$docker_config_tmp" "$docker_config_file"
      else
        echo "Skipping Docker CLI plugin config because $docker_config_file is not valid JSON"
      fi
    else
      printf '%s\n' "$docker_cli_plugin_dirs" \
        | ${pkgs.jq}/bin/jq '{cliPluginsExtraDirs: .}' > "$docker_config_tmp"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mv "$docker_config_tmp" "$docker_config_file"
    fi
  '';

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
