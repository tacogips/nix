{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:tacogips/nixpkgs-security/51712f4618983456364dc94f66736f6a9f942f6c";

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
