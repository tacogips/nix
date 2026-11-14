{
  description = "Darwin minimal system flake";

  inputs = {
    nixpkgs.url = "github:tacogips/nixpkgs-security/4a5495d1c0a7c62200b55deeeecb64f03b093056";

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin"; # For Apple Silicon Macs
      hostName = "taco-mac";
      stateVersions = import ../lib/state-versions.nix { lib = nixpkgs.lib; };
      hostStateVersions = stateVersions.forDarwinHost hostName;
      darwinStateVersion = hostStateVersions.system;
      homeStateVersion = hostStateVersions.home;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      darwinConfigurations = {
        "${hostName}" = darwin.lib.darwinSystem {
          inherit system;
          modules = [
            # Basic Darwin configuration
            {
              # Set hostname
              system.defaults.NSGlobalDomain = {
                AppleKeyboardUIMode = 3;
                ApplePressAndHoldEnabled = false;
                InitialKeyRepeat = 20;
                KeyRepeat = 1;
              };

              # System settings
              system.stateVersion = darwinStateVersion;

              # Nix configuration
              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                trusted-users = [ "@admin" ];
              };

              # Configure fonts
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

              # Enable services
              nix.enable = true;

              # Enable shells
              programs.zsh.enable = true;
              programs.fish.enable = true;

              # Set fish as default shell
              system.primaryUser = "taco";
              users.users.taco = {
                home = "/Users/taco";
                shell = pkgs.fish;
              };
            }

            # Home Manager configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.taco = {
                home.username = "taco";
                home.homeDirectory = "/Users/taco";
                home.stateVersion = homeStateVersion;

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
                  userEmail = "me@example.com"; # Replace with your email
                };
              };
            }
          ];
        };
      };
    };
}
