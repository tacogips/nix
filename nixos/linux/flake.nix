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

    ## --- go tools --------
    ign.url = "github:tacogips/ign";
    kinko.url = "github:tacogips/kinko";

    ## --- apps --------
    qraftbox.url = "git+https://github.com/tacogips/QraftBox.git";
    chilla.url = "github:tacogips/chilla";

    ## --- overlays --------
    nix-overlays.url = "github:tacogips/nix-overlays";

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
      nixpkgs-stable,
      home-manager,
      nvf,
      xremap-flake,
      cratedocs-mcp,
      gitcodes-mcp,
      bravesearch-mcp,
      hn-mcp,
      fenix,
      ign,
      kinko,
      qraftbox,
      chilla,
      nix-overlays,
      firefox-addons,
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
        overlays = [
          nix-overlays.overlays.claude-code
          nix-overlays.overlays.codex
        ];
      };
      stablePkgs = import nixpkgs-stable {
        system = "${system}";
        config = {
          allowUnfree = true;
        };
      };

      # Import our library collision fix function
      fixLibraryCollision = import ./lib/fixLibraryCollision.nix { inherit pkgs; };

      # Get the original packages
      cratedocs-mcp-pkg = cratedocs-mcp.packages.${system}.default;
      bravesearch-mcp-pkg = bravesearch-mcp.packages.${system}.default;
      hn-mcp-pkg = hn-mcp.packages.${system}.default;
      gitcode-mcp-pkg = gitcodes-mcp.packages.${system}.default;
      ign-pkg = ign.packages.${system}.default;
      kinko-pkg = kinko.packages.${system}.default.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./patches/kinko-explosion-password-mask.patch
        ];
      });
      qraftbox-pkg = qraftbox.packages.${system}.default;
      chilla-pkg = chilla.packages.${system}.default;

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
              # Overlays
              {
                nixpkgs.overlays = [
                  nix-overlays.overlays.claude-code
                  nix-overlays.overlays.codex
                ];
              }

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
                    homeStateVersion
                    cratedocs-mcp-pkg
                    bravesearch-mcp-pkg
                    hn-mcp-pkg
                    gitcode-mcp-pkg
                    ign-pkg
                    kinko-pkg
                    qraftbox-pkg
                    chilla-pkg
                    firefox-addons
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
