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
    github-insight-mcp.url = "github:tacogips/github-insight";
    github-edit-mcp.url = "github:tacogips/github-edit";

    ## --- rust --------
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## --- go tools --------
    ign.url = "github:tacogips/ign";

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
      github-insight-mcp,
      github-edit-mcp,
      fenix,
      ign,
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
      cratedocs-mcp-pkg = cratedocs-mcp.packages.${system}.default;
      bravesearch-mcp-pkg = bravesearch-mcp.packages.${system}.default;
      hn-mcp-pkg = hn-mcp.packages.${system}.default;
      gitcode-mcp-pkg = gitcodes-mcp.packages.${system}.default;
      github-insight-mcp-pkg = github-insight-mcp.packages.${system}.default;
      github-edit-mcp-pkg = github-edit-mcp.packages.${system}.default;
      ign-pkg = ign.packages.${system}.default;

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
          "nix-dev-machine" = nixpkgs.lib.nixosSystem {
            inherit system;

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
                    github-insight-mcp-pkg
                    github-edit-mcp-pkg
                    ign-pkg
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
