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

    # Firefox extensions repository from NUR
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## --- mcps --------
    cratedocs-mcp.url = "github:tacogips/cratedocs-mcp";
    bravesearch-mcp.url = "github:tacogips/bravesearch-mcp";
    hn-mcp.url = "github:tacogips/hn-mcp";
    gitcodes-mcp.url = "github:tacogips/gitcodes-mcp";
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      firefox-addons,
      cratedocs-mcp,
      bravesearch-mcp,
      hn-mcp,
      gitcodes-mcp,
      ...
    }:
    let
      system = "aarch64-darwin"; # For Apple Silicon Macs
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [ ];
      };
    in
    {
      darwinConfigurations = {
        "taco-mac" = darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit pkgs; };
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
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                trusted-users = [ "@admin" ];
              };

              # Configure fonts (using updated option names)
              fonts.packages = with pkgs; [
                jetbrains-mono
                nerd-fonts.jetbrains-mono
                iosevka # Add iosevka font for Alacritty
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
              home-manager.backupFileExtension = "backup"; # Automatically backup existing files
              home-manager.extraSpecialArgs = {
                inherit firefox-addons;
                cratedocs-mcp-pkg = cratedocs-mcp.packages.${system}.default;
                bravesearch-mcp-pkg = bravesearch-mcp.packages.${system}.default;
                hn-mcp-pkg = hn-mcp.packages.${system}.default;
                gitcode-mcp-pkg = gitcodes-mcp.packages.${system}.default;
              };
              home-manager.users.taco = { ... }: {
                imports = [
                  ./home-manager
                ];
              };
            }
          ];
        };
      };
    };
}