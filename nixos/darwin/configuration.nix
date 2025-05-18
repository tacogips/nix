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
  
  # Nix configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };
  
  # Configure fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

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
  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  programs.fish.enable = true;
  
  # Set fish as default shell
  users.users.taco = {
    shell = pkgs.fish;
  };

  # Used for backwards compatibility, please read the changelog before changing
  system.stateVersion = 4;  # Darwin state versions continue to use single numbers
}