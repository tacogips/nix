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

    ## --- go tools --------
    kinko.url = "github:tacogips/kinko";

    ## --- mcps --------
    bravesearch-mcp.url = "github:tacogips/bravesearch-mcp";
  };

  outputs =
    {
      bravesearch-mcp,
      darwin,
      home-manager,
      kinko,
      nixpkgs,
      nvf,
      ...
    }:
    let
      mkDarwinConfiguration = import ./lib/mkDarwinConfiguration.nix {
        inherit
          bravesearch-mcp
          darwin
          home-manager
          kinko
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
