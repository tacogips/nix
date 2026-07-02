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

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      darwin,
      home-manager,
      nixpkgs,
      nvf,
      ...
    }:
    let
      mkDarwinConfiguration = import ./lib/mkDarwinConfiguration.nix {
        inherit
          darwin
          home-manager
          nixpkgs
          nvf
          ;
      };
    in
    {
      darwinConfigurations = {
        taco-mac = mkDarwinConfiguration {
          hostName = "taco-mac";
          modules = [
            ./hosts/taco-mac
          ];
        };

        darwin-mac-home-server = mkDarwinConfiguration {
          hostName = "darwin-mac-home-server";
          modules = [
            ./hosts/darwin-mac-home-server
          ];
        };
      };
    };
}
