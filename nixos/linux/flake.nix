{

  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    ## --- mcps --------
    cratedocs-mcp.url = "github:tacogips/cratedocs-mcp";
    bravesearch-mcp.url = "github:tacogips/bravesearch-mcp";
    hn-mcp.url = "github:tacogips/hn-mcp";
    gitcodes-mcp.url = "github:tacogips/gitcodes-mcp";

    ## --- rust --------
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox extensions repository from NUR
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
      gitcodes-mcp,
      bravesearch-mcp,
      hn-mcp,
      fenix,
      firefox-addons,
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
      gitcodes-mcp-orig = gitcodes-mcp.packages.${system}.default;

      # Use the original cratedocs-mcp as the source of the shared library
      cratedocs-mcp-pkg = cratedocs-mcp-orig;

      # Fix collisions in other packages by creating fixed versions with library specifications
      # This approach allows different library mappings for each package if needed
      bravesearch-mcp-pkg = fixLibraryCollision bravesearch-mcp-orig [
        {
          lib = "libhtml2md.so";
          source = cratedocs-mcp-pkg;
        }
        # Example of how to add more libraries with different sources:
        # { lib = "libfoo.so"; source = someOtherPackage; }
      ];

      hn-mcp-pkg = fixLibraryCollision hn-mcp-orig [
        {
          lib = "libhtml2md.so";
          source = cratedocs-mcp-pkg;
        }
        # Each package can have its own set of library mappings
        # { lib = "libbar.so"; source = anotherSourcePackage; }
      ];

      gitcode-mcp-pkg = fixLibraryCollision gitcodes-mcp-orig [
        {
          lib = "libhtml2md.so";
          source = cratedocs-mcp-pkg;
        }
      ];

    in
    {
      nixosConfigurations = {
        "nix-dev-machine" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            # Base configuration
            ./device/nix-dev-machine/configuration.nix
            ./ssh/ssh.nix

            # Service configurations
            ./services/tailscale.nix
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
            ./configuration/tailscale.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmm_backup";
              home-manager.extraSpecialArgs = {
                inherit
                  xremap-flake
                  fenix
                  cratedocs-mcp-pkg
                  bravesearch-mcp-pkg
                  hn-mcp-pkg
                  gitcode-mcp-pkg
                  firefox-addons
                  ;
              };
              home-manager.users.taco =
                { ... }:
                {
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
