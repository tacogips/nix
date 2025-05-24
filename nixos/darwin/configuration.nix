{ pkgs, ... }:

{
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
    # Enable pam_reattach for proper Touch ID support in tmux/screen
    pamReattach = true;
  };
  
  # Preserve HOME environment variable when using sudo
  security.sudo.extraConfig = ''
    Defaults env_keep += "HOME"
  '';
  
  # Nix configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };
  
  # Configure fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono # Updated syntax for nerd-fonts
    ];
  };

  # Enable homebrew
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    taps = [];
    casks = [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install basic system packages
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  # Auto upgrade nix package and the daemon service
  nix.enable = true; # This replaces services.nix-daemon.enable which is deprecated

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  programs.fish.enable = true;
  
  # Add fish to available shells and /etc/shells
  environment.shells = [ pkgs.fish ];
  
  # Add shell to /etc/shells
  environment.etc."shells".text = ''
    # List of acceptable shells for chpass(1).
    # Ftpd will not allow users to connect who are not using
    # one of these shells.
    
    /bin/bash
    /bin/csh
    /bin/dash
    /bin/ksh
    /bin/sh
    /bin/tcsh
    /bin/zsh
    ${pkgs.fish}/bin/fish
  '';
  
  # Set fish as default shell
  users.users.taco = {
    shell = pkgs.fish;
  };

  # Used for backwards compatibility, please read the changelog before changing
  system.stateVersion = 4;  # Darwin state versions continue to use single numbers
}