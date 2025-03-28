{

  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";

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

    in
    {
      nixosConfigurations = {
        "taco-main" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./base/taco-main/configuration.nix
            ./base/taco-main/driver.nix
            ./ssh/ssh.nix

            {
              ## ブートローダー
              #boot.loader.systemd-boot.enable = true;
              #boot.loader.efi.canTouchEfiVariables = true;

              ## ネットワーク設定
              #networking = {
              #  hostName = "hostname";
              #  networkmanager.enable = true;
              #};

              # https://wiki.nixos.org/wiki/Sway#Using_Home_Manager
              #security.polkit.enable = true;

              nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
              };
              nix.settings.auto-optimise-store = true;
              # not needed for rootless
              #nix.settings.trusted-users = [ "taco" ];

              # podman compose not support environemnt secrets for now
              #virtualisation.podman = {
              #  enable = true;
              #  dockerCompat = true;
              #  defaultNetwork.settings.dns_enabled = true;
              #};

              virtualisation.docker = {
                #enable = true;
                #rootless = {
                #  enable = true;
                #  setSocketVariable = true; # setting DOCKER_HOST

                #  daemon.settings = {

                #    debug = true;
                #    dns = [

                #      "1.1.1.1"
                #      "8.8.8.8"
                #      "8.8.4.4"
                #    ];

                #    # debugging =============================================

                #    #"userland-proxy" = true;
                #    #"iptables" = false; # rootlessモードではiptablesを使わない

                #    #"cgroup-parent" = "user.slice";
                #    #"ip-forward" = false;
                #    #"ip-masq" = false;

                #    # debugging =============================================

                #    # deal with error setting rlimit type 8: operation not permitted
                #    #"default-ulimits" = {
                #    #  "memlock" = {
                #    #    "name" = "memlock";
                #    #    "hard" = -1;
                #    #    "soft" = -1;
                #    #  };

                #    "runtimes" = {
                #      "nvidia" = {
                #        "path" = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
                #        "runtimeArgs" = [ ];
                #      };
                #    };
                #    "default-runtime" = "nvidia";

                #  };
                #};

                enable = true;
                rootless = {
                  enable = false;
                  setSocketVariable = false;
                };
                #daemon.settings = {
                #  debug = true;
                #  dns = [
                #    "1.1.1.1"
                #    "8.8.8.8"
                #    "8.8.4.4"
                #  ];

                #  "runtimes" = {
                #    "nvidia" = {
                #      "path" = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
                #      "runtimeArgs" = [ ];
                #    };
                #  };
                #  "default-runtime" = "nvidia";
                #};
              };

              hardware.nvidia-container-toolkit = {
                enable = true;
                package = pkgs.nvidia-container-toolkit;
              };

              # deal with container error. setting rlimit type 8: operation not permitted
              security.pam.loginLimits = [
                {
                  domain = "@wheel";
                  type = "soft";
                  item = "memlock";
                  value = "unlimited";
                }
                {
                  domain = "@wheel";
                  type = "hard";
                  item = "memlock";
                  value = "unlimited";
                }
              ];

              environment.systemPackages = with pkgs; [

                vim
                git
                curl
                fish
                bash
                stdenv.cc.cc.lib

                cudatoolkit
                cudaPackages.cudnn
                cudaPackages.cuda_cudart
                cudaPackages.cuda_cupti
                cudaPackages.cuda_nvrtc
                cudaPackages.cuda_nvtx

              ];

              environment.variables = {
                CUDA_PATH = "${pkgs.cudatoolkit}";
                CUDA_HOME = "${pkgs.cudatoolkit}";
                EXTRA_LDFLAGS = "-L${pkgs.cudatoolkit}/lib/stubs";
                LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
                  pkgs.cudatoolkit
                  pkgs.cudaPackages.cudnn
                  pkgs.cudaPackages.cuda_cudart
                  pkgs.linuxPackages.nvidia_x11
                  pkgs.stdenv.cc.cc.lib
                ];

              };

              fonts = {
                fontDir.enable = true;

                packages = with pkgs; [
                  noto-fonts
                  noto-fonts-cjk-sans
                  noto-fonts-cjk-serif
                  noto-fonts-emoji
                  iosevka
                  helvetica-neue-lt-std
                  nerd-fonts.iosevka
                ];
                fontconfig = {
                  defaultFonts = {
                    serif = [
                      "Noto Serif CJK JP"
                      "Noto Color Emoji"
                    ];
                    sansSerif = [
                      "Noto Sans CJK JP"
                      "Noto Color Emoji"
                    ];
                    monospace = [
                      "Iosevka Nerd Fon"
                      "Noto Color Emoji"
                    ];
                    emoji = [ "Noto Color Emoji" ];
                  };
                };

              };

              services.openssh = {
                enable = true;
                permitRootLogin = "no";
                passwordAuthentication = false;
              };

              services.gnome.gnome-keyring.enable = true;

              # login manager
              services.greetd = {
                enable = true;
                #settings = {
                #  default_session = {
                #    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyperland";
                #    user = "taco";
                #  };
                #};
                settings = {
                  initial_session = {
                    command = "${pkgs.hyprland}/bin/Hyprland";
                    user = "taco";
                  };
                  default_session = {
                    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${pkgs.hyprland}/bin/Hyprland";
                    user = "greeter";
                  };

                };
              };

              programs = {
                hyprland = {
                  enable = true;
                  xwayland.enable = true;
                };

                fish.enable = true;
              };

              # for xremap
              boot.kernelModules = [
                "uinput"
              ];
              # for xremap
              services.udev.extraRules = ''
                KERNEL=="uinput",GROUP="input", TAG+="uaccess"
              '';
              users.users.taco = {
                shell = pkgs.fish;

                extraGroups = [
                  "wheel"
                  "networkmanager"
                  "input"
                  "docker"
                ];
                openssh.authorizedKeys.keyFiles = [
                  ./ssh/authorized-keys-dev-machine
                ];
              };

              # enable screen sharing
              xdg.portal = {
                enable = true;
                extraPortals = [
                  pkgs.xdg-desktop-portal-hyprland
                  pkgs.xdg-desktop-portal-gtk
                ];
                config.hyprland = {
                  "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
                };
              };

            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              #home-manager.sharedModules = [
              #  (
              #    { config, ... }:
              #    {
              #    }
              #  )
              #];
              home-manager.extraSpecialArgs = {
                inherit xremap-flake fenix;
              }; # inputs を渡す
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
