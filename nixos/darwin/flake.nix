{
  description = "Darwin minimal system flake";

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

    # Firefox extensions repository from NUR
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## --- go tools --------
    ign.url = "github:tacogips/ign";
    kinko.url = "github:tacogips/kinko";
    chilla.url = "github:tacogips/chilla";

    ## --- mcps --------
    bravesearch-mcp.url = "github:tacogips/bravesearch-mcp";
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      nvf,
      firefox-addons,
      ign,
      kinko,
      chilla,
      bravesearch-mcp,
      ...
    }:
    let
      system = "aarch64-darwin"; # For Apple Silicon Macs
      hostName = "taco-mac";
      stateVersions = import ../lib/state-versions.nix { lib = nixpkgs.lib; };
      hostStateVersions = stateVersions.forDarwinHost hostName;
      darwinStateVersion = hostStateVersions.system;
      homeStateVersion = hostStateVersions.home;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (final: prev: {
            # Work around a broken nixpkgs direnv derivation on Darwin.
            # The regression came from NixOS/nixpkgs#486452:
            # https://github.com/NixOS/nixpkgs/pull/486452
            # It disabled cgo while direnv still built with
            # -linkmode=external on Darwin, which fails with:
            # "-linkmode=external requires external (cgo) linking, but cgo
            # is not enabled".
            #
            # Upstream fix:
            # https://github.com/NixOS/nixpkgs/commit/a4fb16db2751d9c9e5f3512c697d2ac49d406789
            #
            # This overlay should become unnecessary after the next nixpkgs
            # update that includes that commit.
            direnv = prev.direnv.overrideAttrs (_: {
              allowGoReference = true;
              env = (prev.direnv.env or { }) // {
                CGO_ENABLED = "1";
              };
            });
          })
        ];
      };
      # Get the original packages
      bravesearch-mcp-pkg = bravesearch-mcp.packages.${system}.default;
      ign-pkg = ign.packages.${system}.default;
      kinko-pkg = kinko.packages.${system}.default;
      chilla-pkg = chilla.packages.${system}.default;

    in
    {
      darwinConfigurations = {
        "${hostName}" = darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit
              pkgs
              darwinStateVersion
              ;
          };
          modules = [
            # Basic Darwin configuration
            (
              {
                config,
                darwinStateVersion,
                ...
              }:
              {
                # Set primary user for system defaults
                system.primaryUser = "taco";

                # Set hostname
                system.defaults.NSGlobalDomain = {
                  AppleKeyboardUIMode = 3;
                  ApplePressAndHoldEnabled = false;
                  InitialKeyRepeat = 20;
                  KeyRepeat = 1;
                };

                # System settings
                system.stateVersion = darwinStateVersion;

                # Set nixbld group ID to match actual value
                ids.gids.nixbld = 350;

                # Disable nix-darwin management of Nix installation
                nix.enable = false;

                # Nix settings (still applied even with nix.enable = false)
                nix.settings = {
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  trusted-users = [ "@admin" ];
                };

                # Configure fonts (using updated option names)
                fonts.packages = with pkgs; [
                  jetbrains-mono
                  nerd-fonts.jetbrains-mono
                  iosevka
                ];

                # Allow unfree packages
                nixpkgs.config.allowUnfree = true;

                # Install basic system packages
                environment.systemPackages = with pkgs; [
                  git
                  vim
                  curl
                  wget
                  # zed - Installed via Homebrew (see homebrew.casks below)
                ];

                # Enable shells
                programs.zsh.enable = true;
                programs.fish.enable = true;

                # Set fish as default shell
                users.users.taco = {
                  shell = pkgs.fish;
                };

                # Homebrew configuration
                homebrew = {
                  enable = true;

                  # Update Homebrew and upgrade packages on activation
                  onActivation = {
                    autoUpdate = true;
                    upgrade = true;
                    cleanup = "zap"; # Remove unlisted packages
                  };

                  # GUI applications (casks)
                  casks = [
                    "ghostty" # Ghostty terminal
                    # "zed" # Zed Editor
                    "claude-code" # Claude Code CLI
                    "codex" # OpenAI Codex CLI
                  ];

                  # Command-line tools (brews)
                  brews = [
                    # Add any CLI tools that are better via Homebrew
                  ];

                  # Mac App Store apps (requires mas-cli)
                  masApps = {
                    # "App Name" = appId;
                  };
                };

                # Check for Homebrew (installation must be done manually)
                system.activationScripts.preActivation.text = ''
                  # Check for Homebrew in expected locations
                  if [ -f /opt/homebrew/bin/brew ] || [ -f /usr/local/bin/brew ]; then
                    echo "✅ Homebrew is installed"
                  else
                    echo "⚠️  Homebrew not found!"
                    echo "Please install Homebrew manually:"
                    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                    echo ""
                    echo "After installation, run 'darwin-rebuild switch' again."
                    exit 1
                  fi
                '';

                # Add activation script to set shell for the user
                system.activationScripts.postActivation.text =
                  let
                    user = config.system.primaryUser;
                  in
                  ''
                    # Set fish shell for current user
                    echo "Setting fish as default shell for user ${user}..."
                    sudo chsh -s ${pkgs.fish}/bin/fish ${user}
                  '';
              }
            )

            # Home Manager configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup"; # Automatically backup existing files
              home-manager.extraSpecialArgs = {
                inherit
                  homeStateVersion
                  firefox-addons
                  bravesearch-mcp-pkg
                  ign-pkg
                  kinko-pkg
                  chilla-pkg
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
