{
  description = "Darwin minimal system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
  let
    system = "aarch64-darwin"; # For Apple Silicon Macs
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    darwinConfigurations = {
      "taco-mac" = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          # Basic Darwin configuration
          {
            # Set primary user for system defaults
            system.primaryUser = "taco";
            
            # Set hostname
            system.defaults.NSGlobalDomain = {
              AppleKeyboardUIMode = 3;
              ApplePressAndHoldEnabled = false;
              InitialKeyRepeat = 20;
              KeyRepeat = 1;
            };
            
            # System settings
            system.stateVersion = 4;
            
            # Set nixbld group ID to match actual value
            ids.gids.nixbld = 350;
            
            # Disable nix-darwin management of Nix installation
            nix.enable = false;
            
            # Nix settings (still applied even with nix.enable = false)
            nix.settings = {
              experimental-features = [ "nix-command" "flakes" ];
              trusted-users = [ "@admin" ];
            };
            
            # Configure fonts (using updated option names)
            fonts.packages = with pkgs; [
              jetbrains-mono
              nerd-fonts.jetbrains-mono
            ];
            
            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;
            
            # Install basic system packages
            environment.systemPackages = with pkgs; [
              git
              vim
              curl
              wget
              alacritty
              zed
            ];
            
            # Enable shells
            programs.zsh.enable = true;
            programs.fish.enable = true;
            
            # Set fish as default shell
            users.users.taco = {
              shell = pkgs.fish;
            };
          }
          
          # Home Manager configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.taco = { lib, ... }: with lib; {
              home.username = mkForce "taco";
              home.homeDirectory = mkForce "/Users/taco";
              home.stateVersion = mkForce "24.11";
              
              # Import specific shared platform-independent home-manager modules
              # Avoiding the default.nix to have more control over imports
              imports = [
                ../home-manager/taco/alacritty
                ../home-manager/taco/bat
                ../home-manager/taco/bottom
                ../home-manager/taco/claude
                ../home-manager/taco/direnv
                ../home-manager/taco/eza
                ../home-manager/taco/fd
                ../home-manager/taco/fzf
                ../home-manager/taco/git
                # Removing k9s as it has some configuration issues
                # ../home-manager/taco/k9s
                ../home-manager/taco/lazygit
                ../home-manager/taco/ripgrep
                ../home-manager/taco/ssh
                ../home-manager/taco/yazi
                ../home-manager/taco/zed
                ../home-manager/taco/zellij
                ../home-manager/taco/zoxide
              ];
              
              # Configure fish (simplified version without XDG paths that are Linux-specific)
              programs.fish = {
                enable = true;
                
                # The shell configuration will be more basic for macOS
                # If you want full fish config, we'll need to adapt it for macOS
              };
              
              # Additional Darwin-specific settings or packages
              home.packages = with pkgs; [
                # Add any macOS-specific packages here
              ];
              
              # Override any shared settings that need customization for macOS
              programs.git = {
                userName = mkForce "tacogips";
                userEmail = mkForce "me+darwin@tacogips.me";
              };
            };
          }
        ];
      };
    };
  };
}