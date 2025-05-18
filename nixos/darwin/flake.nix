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
            
            # Add activation script to set shell for the user
            system.activationScripts.postActivation.text = ''
              # Set fish shell for current user
              echo "Setting fish as default shell for user taco..."
              sudo chsh -s ${pkgs.fish}/bin/fish taco
            '';
          }
          
          # Home Manager configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";  # Automatically backup existing files
            home-manager.users.taco = { lib, ... }: with lib; {
              home.username = mkForce "taco";
              home.homeDirectory = mkForce "/Users/taco";
              home.stateVersion = mkForce "24.11";
              
              # Import shared platform-independent home-manager modules
              # Including fish and adapting for macOS
              imports = [
                ../shared-home-manager/taco/fish
              ] ++ (builtins.map (module: ../shared-home-manager/taco/${module}) [
                "alacritty"
                "bat"
                "bottom"
                "claude"
                "direnv"
                "eza"
                "fd"
                "fzf"
                "git"
                # "k9s" # Removed due to compatibility issues
                "lazygit"
                "ripgrep"
                "ssh"
                "yazi"
                "zed"
                "zellij"
                "zoxide"
              ]);
              
              # Override fish configuration for macOS compatibility
              programs.fish = {
                # Basic settings inherited from the shared module
                
                # Override Linux-specific aliases
                shellAliases = lib.mkForce (import ../shared-home-manager/taco/fish/aliases.nix { inherit pkgs; } // {
                  # Remove Linux-specific aliases
                  "update-taco-main" = null; # Remove Linux rebuild command
                  "ppp" = null; # Remove wl-copy command
                  "cdp" = null; # Remove wl-paste command
                  "mozc_config" = null; # Remove Linux-specific tool
                  
                  # Add Darwin-specific aliases
                  "update-taco-mac" = "darwin-rebuild switch --flake ~/nix/nixos/darwin#taco-mac";
                  # Add any other macOS-specific aliases here
                });
                
                # Override Linux-specific functions
                functions = lib.mkForce (removeAttrs (import ../shared-home-manager/taco/fish/functions.nix { inherit pkgs; }) [
                  "capture_active"  # Remove Hyprland-specific functions
                  "capture_sel"     # Remove Wayland-specific functions
                  "capture_sel_video" # Remove Wayland-specific functions
                ]);
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