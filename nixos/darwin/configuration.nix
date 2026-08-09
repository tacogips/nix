{
  pkgs,
  darwinStateVersion ? 4,
  ...
}:

{
  # DNS configuration
  networking = {
    dns = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  # System configuration
  system = {
    # Set hostname
    defaults.NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 20;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      _HIHideMenuBar = false;
    };
  };

  # Enable Touch ID for sudo authentication
  security.pam.services.sudo_local = {
    # This enables Touch ID for sudo using the new sudo_local file
    touchIdAuth = true;
  };

  # Preserve HOME environment variable when using sudo
  security.sudo.extraConfig = ''
    Defaults env_keep += "HOME"
  '';

  # Nix configuration
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "@admin" ];
  };

  # Migrated to tacogips/mise-darwin/Brewfile.common.
  # fonts = {
  #   fontDir.enable = true;
  #   packages = with pkgs; [
  #     jetbrains-mono
  #     nerd-fonts.jetbrains-mono
  #   ];
  # };

  # Enable homebrew
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "none";
    taps = [ "tacogips/tap" ];
    brews = [
      # Wrike API CLI: installs wrike-gateway-reader/-writer/-admin
      "tacogips/tap/wrike-gateway"
    ];
    casks = [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Handle package collisions
  nixpkgs.config.allowAliases = true;
  nixpkgs.config.permittedInsecurePackages = [ ];

  # Allow collisions in environment.systemPackages
  environment.pathsToLink = [ "/Applications" ];
  environment.variables.NIX_IGNORE_COLLISIONS = "1";

  # Migrated to tacogips/mise-darwin ([bootstrap.packages]).
  # environment.systemPackages = with pkgs; [
  #   git
  #   vim
  #   curl
  #   wget
  # ];

  # Auto upgrade nix package and the daemon service
  nix.enable = true; # This replaces services.nix-daemon.enable which is deprecated

  # Create /etc/zshrc that loads the nix-darwin environment
  # Shell binaries and activation are managed by mise-darwin/Homebrew.
  # programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Add fish to available shells and /etc/shells
  # environment.shells = [ pkgs.fish ];

  # Add shell to /etc/shells
  # mise bootstrap adds Homebrew Fish to /etc/shells.
  # environment.etc."shells".text = ''...'';

  # Set fish as default shell
  # users.users.taco = {
  #   shell = pkgs.fish;
  # };

  # Used for backwards compatibility, please read the changelog before changing
  system.stateVersion = darwinStateVersion; # nix-darwin uses integer compatibility versions.
}
