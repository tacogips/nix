{

  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    ## --- rust --------
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nvf,
      xremap-flake,
      fenix,
      ...
    }:
    let
      system = "x86_64-linux";
      hostName = "nix-dev-machine";
      stateVersions = import ../lib/state-versions.nix { lib = nixpkgs.lib; };
      hostStateVersions = stateVersions.forNixosHost hostName;
      nixosStateVersion = hostStateVersions.system;
      homeStateVersion = hostStateVersions.home;
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        system = "${system}";
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };
      stablePkgs = import nixpkgs-stable {
        system = "${system}";
        config = {
          allowUnfree = true;
        };
      };

      # Import our library collision fix function
      fixLibraryCollision = import ./lib/fixLibraryCollision.nix { inherit pkgs; };

    in
    {
      nixosConfigurations =
        let
          # Docker module with custom data root for nix-dev-machine
          nixDevMachineDockerModule =
            {
              config,
              lib,
              pkgs,
              ...
            }:
            import ./services/docker.nix {
              inherit
                config
                lib
                pkgs
                ;
              dataRoot = "/g/docker";
            };
        in
        {
          "${hostName}" = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit nixosStateVersion;
            };

            modules = [
              # Base configuration
              ./device/nix-dev-machine/configuration.nix
              ./ssh/ssh.nix

              # Service configurations
              ./services/tailscale.nix
              nixDevMachineDockerModule
              ./services/openssh.nix
              ./services/gnome-keyring.nix
              ./services/greetd.nix
              ./services/xdg-portal.nix

              # Hardware configurations
              ./hardware/fan-control.nix
              ./hardware/cuda.nix
              ./hardware/storage.nix
              ./hardware/nvidia.nix

              # Program configurations
              ./programs/hyprland.nix

              # System configurations
              ./configuration/dbus.nix
              ./configuration/fonts.nix
              ./configuration/users.nix
              ./configuration/networking.nix
              ./configuration/nix-settings.nix
              ./configuration/system-packages.nix
              ./configuration/kernel-modules.nix
              ./configuration/tailscale.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "hmm_backup";
                home-manager.overwriteBackup = true;
                home-manager.extraSpecialArgs = {
                  inherit
                    xremap-flake
                    fenix
                    homeStateVersion
                    stablePkgs
                    ;
                };
                home-manager.users.taco =
                  { ... }:
                  {
                    imports = [
                      ./home-manager
                      nvf.homeManagerModules.default
                    ];
                  };
              }
            ];
          };
        };
    };

}
