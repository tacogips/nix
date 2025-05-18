{
  description = "Darwin system flake";

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

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
  let
    system = "aarch64-darwin"; # For Apple Silicon Macs
    # system = "x86_64-darwin"; # Uncomment for Intel Macs
    
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    darwinConfigurations = {
      "taco-mac" = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          # Darwin configuration
          ./configuration.nix
          
          # Home Manager configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.taco = { ... }: {
              imports = [ ./home-manager ];
              home.username = "taco";
              home.homeDirectory = "/Users/taco";
              home.stateVersion = "24.11";
            };
          }
        ];
      };
    };
  };
}