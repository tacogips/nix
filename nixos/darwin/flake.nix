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
              
              # Basic Home Manager configuration
              programs.home-manager.enable = true;
              
              # Install basic user packages
              home.packages = with pkgs; [
                ripgrep
                fd
                bat
                eza
              ];
              
              # Configure Git
              programs.git = {
                enable = true;
                userName = "tacogips";
                userEmail = "me@example.com";  # Replace with your email
              };
            };
          }
        ];
      };
    };
  };
}