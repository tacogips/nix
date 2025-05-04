{

  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    cratedocs-mcp.url = "github:tacogips/cratedocs-mcp";
    bravesearch-mcp.url = "github:tacogips/bravesearch-mcp";
    hn-mcp.url = "github:tacogips/hn-mcp";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      xremap-flake,
      cratedocs-mcp,
      bravesearch-mcp,
      hn-mcp,
      fenix,
      ...
    }:
    let
      system = "x86_64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        system = "${system}";
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };

      # Import our library collision fix function
      fixLibraryCollision = import ./lib/fixLibraryCollision.nix { inherit pkgs; };
      
      # Get the original packages
      cratedocs-mcp-orig = cratedocs-mcp.packages.${system}.default;
      bravesearch-mcp-orig = bravesearch-mcp.packages.${system}.default;
      hn-mcp-orig = hn-mcp.packages.${system}.default;
      
      # Use the original cratedocs-mcp as the source of the shared library
      cratedocs-mcp-pkg = cratedocs-mcp-orig;
      
      # Fix collisions in other packages by creating fixed versions with library specifications
      # This approach allows different library mappings for each package if needed
      bravesearch-mcp-pkg = fixLibraryCollision bravesearch-mcp-orig [
        { lib = "libhtml2md.so"; source = cratedocs-mcp-pkg; }
        # Example of how to add more libraries with different sources:
        # { lib = "libfoo.so"; source = someOtherPackage; }
      ];
      
      hn-mcp-pkg = fixLibraryCollision hn-mcp-orig [
        { lib = "libhtml2md.so"; source = cratedocs-mcp-pkg; }
        # Each package can have its own set of library mappings
        # { lib = "libbar.so"; source = anotherSourcePackage; }
      ];

    in
    {
      nixosConfigurations = {
        "taco-main" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            # Base configuration
            ./base/taco-main/configuration.nix
            ./ssh/ssh.nix
            
            # Service configurations
            (import ./services/tailscale.nix { permitCertUid = "taco"; })
            ./services/docker.nix
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
            ./configuration/fonts.nix
            ./configuration/users.nix
            ./configuration/networking.nix
            ./configuration/nix-settings.nix
            ./configuration/system-packages.nix
            ./configuration/kernel-modules.nix

            {
              # Any remaining configuration that hasn't been moved into separate files
              
              ## ブートローダー (commented out)
              #boot.loader.systemd-boot.enable = true;
              #boot.loader.efi.canTouchEfiVariables = true;

              ## ネットワーク設定 (commented out)
              #networking = {
              #  hostName = "hostname";
              #  networkmanager.enable = true;
              #};

              # https://wiki.nixos.org/wiki/Sway#Using_Home_Manager (commented out)
              #security.polkit.enable = true;
              
              # not needed for rootless (commented out)
              #nix.settings.trusted-users = [ "taco" ];

              # podman compose (commented out)
              #virtualisation.podman = {
              #  enable = true;
              #  dockerCompat = true;
              #  defaultNetwork.settings.dns_enabled = true;
              #};
              
              # Commented out docker configuration
              #daemon.settings = {
              #  debug = true;
              #  dns = [
              #    "1.1.1.1"
              #    "8.8.8.8"
              #    "8.8.4.4"
              #  ];
              #
              #  "runtimes" = {
              #    "nvidia" = {
              #      "path" = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
              #      "runtimeArgs" = [ ];
              #    };
              #  };
              #  "default-runtime" = "nvidia";
              #};
              
              # web ui for llama (commented out)
              #services.open-webui = {
              #  enable = true;
              #  environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
              #};
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmm_backup";
              #home-manager.sharedModules = [
              #  (
              #    { config, ... }:
              #    {
              #    }
              #  )
              #];
              home-manager.extraSpecialArgs = {
                inherit
                  xremap-flake
                  fenix
                  cratedocs-mcp-pkg
                  bravesearch-mcp-pkg
                  hn-mcp-pkg
                  ;
              };
              home-manager.users.taco =
                { ... }:
                {
                  imports = [
                    ./hm/taco/home.nix
                  ];
                };
            }
          ];
        };
      };
    };

}
