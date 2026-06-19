{
  bravesearch-mcp,
  darwin,
  home-manager,
  nixpkgs,
  nvf,
}:

{
  hostName,
  modules,
  system ? "aarch64-darwin",
  user ? "taco",
  homeModules ? [ ],
  extraSpecialArgs ? { },
  overlays ? import ../packages/overlays.nix,
}:

let
  stateVersions = import ../../lib/state-versions.nix { lib = nixpkgs.lib; };
  hostStateVersions = stateVersions.forDarwinHost hostName;
  darwinStateVersion = hostStateVersions.system;
  homeStateVersion = hostStateVersions.home;

  pkgs = import nixpkgs {
    inherit system overlays;
    config = {
      allowUnfree = true;
    };
  };

  flakeInputPackages = import ../packages/flake-inputs.nix {
    inherit
      bravesearch-mcp
      system
      ;
  };
in
darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit
      darwinStateVersion
      hostName
      pkgs
      user
      ;
  };

  modules = modules ++ [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs =
        flakeInputPackages
        // {
          inherit homeStateVersion;
        }
        // extraSpecialArgs;
      home-manager.users.${user} =
        { ... }:
        {
          imports = [
            ../home-manager
            nvf.homeManagerModules.default
          ]
          ++ homeModules;
        };
    }
  ];
}
